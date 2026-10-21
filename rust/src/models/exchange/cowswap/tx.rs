//! CoW Protocol quote orchestration, ERC-20 `GPv2VaultRelayer` approval check, off-chain order
//! submission (`POST /api/v1/orders`), on-chain `CoWSwapEthFlow.createOrder` transaction builder,
//! WETH wrap/unwrap builder, and order status / off-chain cancellation helpers.

use std::str::FromStr;
use std::time::Duration;

use flutter_rust_bridge::frb;
use zilpay::alloy::hex;
use zilpay::alloy::primitives::{Address, B256, U256};
use zilpay::alloy::sol;
use zilpay::alloy::sol_types::SolCall;
use zilpay::background::bg_provider::ProvidersManagement;
use zilpay::proto::tx::{ETHTransactionRequest, TransactionMetadata, TransactionRequest};
use zilpay::proto::AlloyTxKind;
use zilpay::reqwest;
use zilpay::rpc::{
    common::JsonRPC, methods::EvmMethods, network_config::ChainConfig, provider::RpcProvider,
    zil_interfaces::ResultRes,
};
use zilpay::serde::{Deserialize, Serialize};
use zilpay::serde_json::{self, json, Value};

use crate::models::exchange::cowswap::appdata::build_cow_app_data;
use crate::models::exchange::cowswap::order::{
    compute_cow_amounts, ethflow_order_uid, order_typed_data_json, CowOrderCancellationRequest,
    CowOrderCreation, CowQuoteRequest, CowQuoteResponse, DEFAULT_VALID_FOR_SECS,
};
use crate::models::exchange::cowswap::{
    is_wrap_unwrap, resolve_buy_token, resolve_sell_token, wrapped_native_for_chain, CowMeta,
    COW_ETH_FLOW,
};
use crate::models::exchange::univ_router::PreparedSwap;
use crate::models::exchange::{AppFeeConfig, ExchangeAsset, ProviderQuote, APP_FEE_BPS};
use crate::models::transactions::base_token::BaseTokenInfo;
use crate::models::transactions::request::{CowOrderInfo, TransactionRequestInfo};
use crate::models::transactions::transaction_metadata::TransactionMetadataInfo;
use crate::utils::errors::ServiceError;
use crate::utils::helpers::with_service;

const DEFAULT_APPROVE_GAS: u64 = 60_000;
const DEFAULT_WRAP_GAS: u64 = 60_000;
const DEFAULT_ETHFLOW_GAS: u64 = 180_000;

sol! {
    interface IERC20 {
        function allowance(address owner, address spender) external view returns (uint256);
        function approve(address spender, uint256 amount) external returns (bool);
    }

    interface IWETH {
        function deposit() external payable;
        function withdraw(uint256 amount) external;
    }

    struct EthFlowOrderData {
        address buyToken;
        address receiver;
        uint256 sellAmount;
        uint256 buyAmount;
        bytes32 appData;
        uint256 feeAmount;
        uint32 validTo;
        bool partiallyFillable;
        int64 quoteId;
    }

    interface ICoWSwapEthFlow {
        function createOrder(EthFlowOrderData order) external payable returns (bytes32 orderHash);
    }
}

#[frb(ignore)]
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(crate = "zilpay::serde")]
pub struct CowQuoteBlob {
    pub chain_id: u64,
    pub orderbook_url: String,
    pub settlement: String,
    pub wrapped_native: String,
    pub sell_token: String,
    pub buy_token: String,
    pub receiver: String,
    pub sell_amount: String,
    pub buy_amount: String,
    pub valid_to: u32,
    pub app_data: String,
    pub app_data_hash: String,
    pub quote_id: Option<i64>,
    pub is_native_in: bool,
    pub is_wrap_unwrap: bool,
}

#[frb(ignore)]
pub(crate) fn cow_client() -> &'static reqwest::Client {
    static CLIENT: std::sync::OnceLock<reqwest::Client> = std::sync::OnceLock::new();
    CLIENT.get_or_init(|| {
        reqwest::Client::builder()
            .timeout(Duration::from_secs(15))
            .build()
            .unwrap_or_else(|_| reqwest::Client::new())
    })
}

/// Format an API error returned by the CoW Orderbook (`{"errorType":"...","description":"..."}`).
fn format_cow_api_error(status: reqwest::StatusCode, body: &str) -> String {
    if let Ok(v) = serde_json::from_str::<Value>(body) {
        let err_type = v.get("errorType").and_then(Value::as_str).unwrap_or("");
        let desc = v.get("description").and_then(Value::as_str).unwrap_or("");
        if !err_type.is_empty() || !desc.is_empty() {
            return format!("CoW API ({status}): {err_type} - {desc}");
        }
    }
    format!("CoW API ({status}): {body}")
}

#[frb(ignore)]
pub async fn post_cow_quote(
    orderbook_url: &str,
    req: &CowQuoteRequest<'_>,
) -> Result<CowQuoteResponse, String> {
    let url = format!("{orderbook_url}/api/v1/quote");
    let payload = serde_json::to_string(req).map_err(|e| e.to_string())?;
    let resp = cow_client()
        .post(&url)
        .header("content-type", "application/json")
        .header("accept", "application/json")
        .body(payload)
        .send()
        .await
        .map_err(|e| format!("{url}: {e}"))?;

    let status = resp.status();
    let body = resp.text().await.map_err(|e| format!("{url}: {e}"))?;
    if !status.is_success() {
        return Err(format_cow_api_error(status, &body));
    }

    serde_json::from_str::<CowQuoteResponse>(&body).map_err(|e| format!("{url}: decode {e}"))
}

/// Pre-register the `fullAppData` JSON pre-image with the CoW Orderbook (`PUT /api/v1/app_data/{appDataHash}`)
/// so that `appData` in `/api/v1/quote`, `/api/v1/orders`, and on-chain EthFlow orders can use the
/// canonical 32-byte `appDataHash` while the orderbook knows its full JSON pre-image.
#[frb(ignore)]
pub async fn put_cow_app_data(
    orderbook_url: &str,
    app_data_hash: &str,
    full_app_data: &str,
) -> Result<(), String> {
    static REGISTERED: std::sync::OnceLock<std::sync::Mutex< std::collections::HashSet<(String, String)> >> =
        std::sync::OnceLock::new();
    let key = (orderbook_url.to_string(), app_data_hash.to_string());
    if let Ok(guard) = REGISTERED
        .get_or_init(|| std::sync::Mutex::new(std::collections::HashSet::new()))
        .lock()
    {
        if guard.contains(&key) {
            return Ok(());
        }
    }

    let url = format!("{orderbook_url}/api/v1/app_data/{app_data_hash}");
    let payload = json!({ "fullAppData": full_app_data }).to_string();
    let resp = cow_client()
        .put(&url)
        .header("content-type", "application/json")
        .header("accept", "application/json")
        .body(payload)
        .send()
        .await
        .map_err(|e| format!("{url}: {e}"))?;

    let status = resp.status();
    if status.is_success() {
        if let Ok(mut guard) = REGISTERED
            .get_or_init(|| std::sync::Mutex::new(std::collections::HashSet::new()))
            .lock()
        {
            guard.insert(key);
        }
        return Ok(());
    }
    let body = resp.text().await.unwrap_or_default();
    Err(format_cow_api_error(status, &body))
}

#[frb(ignore)]
pub async fn post_cow_order(
    orderbook_url: &str,
    order: &CowOrderCreation,
) -> Result<String, String> {
    let url = format!("{orderbook_url}/api/v1/orders");
    let payload = serde_json::to_string(order).map_err(|e| e.to_string())?;
    let resp = cow_client()
        .post(&url)
        .header("content-type", "application/json")
        .header("accept", "application/json")
        .body(payload)
        .send()
        .await
        .map_err(|e| format!("{url}: {e}"))?;

    let status = resp.status();
    let body = resp.text().await.map_err(|e| format!("{url}: {e}"))?;
    if !status.is_success() {
        return Err(format_cow_api_error(status, &body));
    }

    // CoW returns the UID as a JSON string `"0x..."`. Fall back to trimmed raw text if unquoted.
    if let Ok(uid) = serde_json::from_str::<String>(&body) {
        Ok(uid)
    } else {
        Ok(body.trim().trim_matches('"').to_string())
    }
}

/// Poll the live status of a CoW order (`"open"`, `"fulfilled"`, `"cancelled"`, `"expired"`,
/// `"presignaturePending"`). For EthFlow orders that have not yet been indexed by the watch-tower,
/// HTTP 404 is reported as `"indexing"` so the UI continues polling until the on-chain tx is mined.
#[frb(ignore)]
pub async fn fetch_cow_order_status(orderbook_url: &str, uid: &str) -> Result<String, String> {
    let url = format!("{orderbook_url}/api/v1/orders/{uid}");
    let resp = cow_client()
        .get(&url)
        .header("accept", "application/json")
        .send()
        .await
        .map_err(|e| format!("{url}: {e}"))?;

    let status = resp.status();
    if status == reqwest::StatusCode::NOT_FOUND {
        return Ok("indexing".to_string());
    }
    let body = resp.text().await.map_err(|e| format!("{url}: {e}"))?;
    if !status.is_success() {
        return Err(format_cow_api_error(status, &body));
    }

    let parsed: super::order::CowOrderStatusResponse =
        serde_json::from_str(&body).map_err(|e| format!("{url}: decode {e}"))?;
    Ok(parsed.status)
}

/// Submit an off-chain EIP-712 `OrderCancellations` signature to `DELETE /api/v1/orders`.
#[frb(ignore)]
pub async fn delete_cow_order(
    orderbook_url: &str,
    uid: &str,
    signature: &str,
) -> Result<(), String> {
    let url = format!("{orderbook_url}/api/v1/orders");
    let req = CowOrderCancellationRequest {
        order_uids: vec![uid.to_string()],
        signature: signature.to_string(),
        signing_scheme: "eip712".to_string(),
    };
    let payload = serde_json::to_string(&req).map_err(|e| e.to_string())?;
    let resp = cow_client()
        .delete(&url)
        .header("content-type", "application/json")
        .header("accept", "application/json")
        .body(payload)
        .send()
        .await
        .map_err(|e| format!("{url}: {e}"))?;

    let status = resp.status();
    if status.is_success() {
        return Ok(());
    }
    let body = resp.text().await.unwrap_or_default();
    Err(format_cow_api_error(status, &body))
}

#[frb(ignore)]
pub async fn cowswap_quote_info(
    meta: &CowMeta,
    from: &ExchangeAsset,
    to: &ExchangeAsset,
    from_asset: &str,
    to_asset: &str,
    amount: &str,
) -> Result<ProviderQuote, String> {
    if from.token.chain_hash != to.token.chain_hash {
        return Err("cross-chain swap not supported".to_string());
    }
    if is_wrap_unwrap(meta, from, to, from_asset, to_asset)? {
        return Ok(ProviderQuote {
            amount_out: amount.to_string(),
            permit_typed_data_json: None,
            is_wrap_unwrap: true,
        });
    }

    let sell_token = resolve_sell_token(meta.common.chain_id, from.token.native, from_asset)?;
    let buy_token = resolve_buy_token(to.token.native, to_asset)?;
    let app_data = build_cow_app_data(Some(AppFeeConfig::default_fee()));
    let is_native_in = from.token.native;

    let _ = put_cow_app_data(
        &meta.orderbook_url,
        &app_data.app_data_hash,
        &app_data.full_app_data,
    )
    .await;

    let req = CowQuoteRequest {
        sell_token: sell_token.as_ref(),
        buy_token: buy_token.as_ref(),
        receiver: meta.common.account_addr.as_str(),
        app_data: &app_data.app_data_hash,
        app_data_hash: None,
        sell_token_balance: "erc20",
        buy_token_balance: "erc20",
        from: meta.common.account_addr.as_str(),
        price_quality: "optimal",
        signing_scheme: if is_native_in { "eip1271" } else { "eip712" },
        onchain_order: is_native_in,
        kind: "sell",
        sell_amount_before_fee: amount,
        valid_for: DEFAULT_VALID_FOR_SECS,
    };

    let resp = post_cow_quote(&meta.orderbook_url, &req).await?;
    let computed = compute_cow_amounts(&resp, APP_FEE_BPS, meta.cfg.default_slippage_bps)?;

    let permit_typed_data_json = if is_native_in {
        None
    } else {
        Some(order_typed_data_json(
            meta.common.chain_id,
            &meta.settlement,
            sell_token.as_ref(),
            buy_token.as_ref(),
            &meta.common.account_addr,
            &computed.order_sell_amount.to_string(),
            &computed.order_buy_amount.to_string(),
            resp.quote.valid_to,
            &app_data.app_data_hash,
        ))
    };

    Ok(ProviderQuote {
        amount_out: computed.expected_buy_amount.to_string(),
        permit_typed_data_json,
        is_wrap_unwrap: false,
    })
}

/// Check whether the user's ERC-20 token has enough allowance for `GPv2VaultRelayer` to pull.
/// Native-in (EthFlow) and wrap/unwrap operations never need ERC-20 approval on the vault relayer.
#[frb(ignore)]
pub async fn cowswap_check_approval(
    meta: &CowMeta,
    from: &ExchangeAsset,
    to: &ExchangeAsset,
    amount: &str,
    approve_title: String,
    provider_icon: String,
) -> Result<Option<TransactionRequestInfo>, String> {
    if from.token.native
        || is_wrap_unwrap(
            meta,
            from,
            to,
            from.token.addr.as_str(),
            to.token.addr.as_str(),
        )?
    {
        return Ok(None);
    }

    let swapper = Address::from_str(&meta.common.account_addr).map_err(|e| e.to_string())?;
    let spender = Address::from_str(&meta.vault_relayer).map_err(|e| e.to_string())?;
    let token_addr = Address::from_str(&from.token.addr).map_err(|e| e.to_string())?;
    let chain_hash = meta.common.chain_hash;

    let config = with_service(|core| {
        Ok(core
            .get_provider(chain_hash)
            .map_err(ServiceError::BackgroundError)?
            .config
            .clone())
    })
    .await
    .map_err(|e: ServiceError| e.to_string())?;

    let call = IERC20::allowanceCall {
        owner: swapper,
        spender,
    }
    .abi_encode();

    let payload = RpcProvider::<ChainConfig>::build_payload(
        json!([{ "to": from.token.addr, "data": hex::encode_prefixed(&call) }, "latest"]),
        EvmMethods::Call,
    );

    let provider: RpcProvider<ChainConfig> = RpcProvider::new(&config);
    let res = provider
        .req::<ResultRes<Value>>(payload)
        .await
        .map_err(|e| e.to_string())?;

    let current = res
        .result
        .as_ref()
        .and_then(|v| v.as_str())
        .and_then(|s| hex::decode(s).ok())
        .and_then(|b| IERC20::allowanceCall::abi_decode_returns(&b).ok())
        .unwrap_or(U256::ZERO);

    let needed = U256::from_str(amount).map_err(|e| e.to_string())?;
    if current >= needed {
        return Ok(None);
    }

    let data = IERC20::approveCall {
        spender,
        amount: U256::MAX,
    }
    .abi_encode();

    let mut tx = ETHTransactionRequest {
        to: Some(AlloyTxKind::Call(token_addr)),
        from: Some(swapper),
        value: Some(U256::ZERO),
        input: data.into(),
        gas: Some(DEFAULT_APPROVE_GAS),
        ..Default::default()
    };
    tx.chain_id = Some(meta.common.chain_id);

    Ok(Some(
        TransactionRequest::Ethereum((
            tx,
            TransactionMetadata {
                chain_hash,
                broadcast: true,
                title: Some(approve_title),
                icon: Some(provider_icon),
                ..Default::default()
            },
        ))
        .try_into()
        .map_err(|e: zilpay::errors::tx::TransactionErrors| e.to_string())?,
    ))
}

#[frb(ignore)]
pub async fn cowswap_prepare_swap(
    meta: &CowMeta,
    from: &ExchangeAsset,
    to: &ExchangeAsset,
    amount: &str,
    slippage_bps: u32,
) -> Result<PreparedSwap, String> {
    if from.token.chain_hash != to.token.chain_hash {
        return Err("cross-chain swap not supported".to_string());
    }

    let chain_id = meta.common.chain_id;
    let wrapped_native = wrapped_native_for_chain(chain_id)
        .ok_or_else(|| format!("unsupported CoW chain {chain_id}"))?
        .to_string();
    let wrap = is_wrap_unwrap(
        meta,
        from,
        to,
        from.token.addr.as_str(),
        to.token.addr.as_str(),
    )?;

    if wrap {
        let blob = CowQuoteBlob {
            chain_id,
            orderbook_url: meta.orderbook_url.clone(),
            settlement: meta.settlement.clone(),
            wrapped_native: wrapped_native.clone(),
            sell_token: wrapped_native.clone(),
            buy_token: wrapped_native,
            receiver: meta.common.account_addr.clone(),
            sell_amount: amount.to_string(),
            buy_amount: amount.to_string(),
            valid_to: 0,
            app_data: String::new(),
            app_data_hash: String::new(),
            quote_id: None,
            is_native_in: from.token.native,
            is_wrap_unwrap: true,
        };
        return Ok(PreparedSwap {
            permit_typed_data_json: None,
            quote_blob: serde_json::to_string(&blob).map_err(|e| e.to_string())?,
        });
    }

    let is_native_in = from.token.native;
    let sell_token = resolve_sell_token(chain_id, is_native_in, from.token.addr.as_str())?;
    let buy_token = resolve_buy_token(to.token.native, to.token.addr.as_str())?;
    let app_data = build_cow_app_data(Some(AppFeeConfig::default_fee()));

    let _ = put_cow_app_data(
        &meta.orderbook_url,
        &app_data.app_data_hash,
        &app_data.full_app_data,
    )
    .await;

    let req = CowQuoteRequest {
        sell_token: sell_token.as_ref(),
        buy_token: buy_token.as_ref(),
        receiver: meta.common.account_addr.as_str(),
        app_data: &app_data.app_data_hash,
        app_data_hash: None,
        sell_token_balance: "erc20",
        buy_token_balance: "erc20",
        from: meta.common.account_addr.as_str(),
        price_quality: "optimal",
        signing_scheme: if is_native_in { "eip1271" } else { "eip712" },
        onchain_order: is_native_in,
        kind: "sell",
        sell_amount_before_fee: amount,
        valid_for: DEFAULT_VALID_FOR_SECS,
    };

    let resp = post_cow_quote(&meta.orderbook_url, &req).await?;
    let computed = compute_cow_amounts(&resp, APP_FEE_BPS, slippage_bps)?;

    let sell_amount_str = computed.order_sell_amount.to_string();
    let buy_amount_str = computed.order_buy_amount.to_string();

    let permit_typed_data_json = if is_native_in {
        None
    } else {
        Some(order_typed_data_json(
            chain_id,
            &meta.settlement,
            sell_token.as_ref(),
            buy_token.as_ref(),
            &meta.common.account_addr,
            &sell_amount_str,
            &buy_amount_str,
            resp.quote.valid_to,
            &app_data.app_data_hash,
        ))
    };

    let blob = CowQuoteBlob {
        chain_id,
        orderbook_url: meta.orderbook_url.clone(),
        settlement: meta.settlement.clone(),
        wrapped_native,
        sell_token: sell_token.into_owned(),
        buy_token: buy_token.into_owned(),
        receiver: meta.common.account_addr.clone(),
        sell_amount: sell_amount_str,
        buy_amount: buy_amount_str,
        valid_to: resp.quote.valid_to,
        app_data: app_data.full_app_data,
        app_data_hash: app_data.app_data_hash,
        quote_id: resp.id,
        is_native_in,
        is_wrap_unwrap: false,
    };

    Ok(PreparedSwap {
        permit_typed_data_json,
        quote_blob: serde_json::to_string(&blob).map_err(|e| e.to_string())?,
    })
}

/// Build an `IWETH.deposit()` or `IWETH.withdraw(amount)` Ethereum transaction.
#[frb(ignore)]
pub fn build_weth_wrap_tx(
    weth: Address,
    chain_id: u64,
    chain_hash: u64,
    from: Address,
    amount: &str,
    is_native_in: bool,
    swap_title: String,
    swap_info: String,
    provider_icon: String,
    out_token: Option<BaseTokenInfo>,
) -> Result<TransactionRequestInfo, String> {
    let amt = U256::from_str(amount).map_err(|e| e.to_string())?;
    let (data, value) = if is_native_in {
        (IWETH::depositCall {}.abi_encode(), amt)
    } else {
        (IWETH::withdrawCall { amount: amt }.abi_encode(), U256::ZERO)
    };

    let mut tx = ETHTransactionRequest {
        to: Some(AlloyTxKind::Call(weth)),
        from: Some(from),
        value: Some(value),
        input: data.into(),
        gas: Some(DEFAULT_WRAP_GAS),
        ..Default::default()
    };
    tx.chain_id = Some(chain_id);

    TransactionRequest::Ethereum((
        tx,
        TransactionMetadata {
            chain_hash,
            broadcast: true,
            title: Some(swap_title),
            info: Some(swap_info),
            icon: Some(provider_icon),
            token_info: out_token.map(|t| {
                (
                    U256::from_str(&t.value).unwrap_or_default(),
                    t.decimals,
                    t.symbol,
                )
            }),
            ..Default::default()
        },
    ))
    .try_into()
    .map_err(|e: zilpay::errors::tx::TransactionErrors| e.to_string())
}

/// Build a `CoWSwapEthFlow.createOrder(EthFlowOrder.Data)` transaction and compute its
/// deterministic 56-byte `orderUid`.
#[allow(clippy::too_many_arguments)]
#[frb(ignore)]
pub fn build_ethflow_tx(
    blob: &CowQuoteBlob,
    chain_hash: u64,
    swapper: Address,
    swap_title: String,
    swap_info: String,
    provider_icon: String,
    out_token: Option<BaseTokenInfo>,
) -> Result<TransactionRequestInfo, String> {
    let eth_flow = Address::from_str(COW_ETH_FLOW).map_err(|e| e.to_string())?;
    let settlement = Address::from_str(&blob.settlement).map_err(|e| e.to_string())?;
    let wrapped_native = Address::from_str(&blob.wrapped_native).map_err(|e| e.to_string())?;
    let buy_token = Address::from_str(&blob.buy_token).map_err(|e| e.to_string())?;
    let receiver = Address::from_str(&blob.receiver).map_err(|e| e.to_string())?;
    let sell_amount = U256::from_str(&blob.sell_amount).map_err(|e| e.to_string())?;
    let buy_amount = U256::from_str(&blob.buy_amount).map_err(|e| e.to_string())?;
    let app_data_hash = B256::from_str(&blob.app_data_hash).map_err(|e| e.to_string())?;

    let data = ICoWSwapEthFlow::createOrderCall {
        order: EthFlowOrderData {
            buyToken: buy_token,
            receiver,
            sellAmount: sell_amount,
            buyAmount: buy_amount,
            appData: app_data_hash,
            feeAmount: U256::ZERO,
            validTo: blob.valid_to,
            partiallyFillable: false,
            quoteId: blob.quote_id.unwrap_or(0),
        },
    }
    .abi_encode();

    let mut tx = ETHTransactionRequest {
        to: Some(AlloyTxKind::Call(eth_flow)),
        from: Some(swapper),
        value: Some(sell_amount),
        input: data.into(),
        gas: Some(DEFAULT_ETHFLOW_GAS),
        ..Default::default()
    };
    tx.chain_id = Some(blob.chain_id);

    let uid = ethflow_order_uid(
        blob.chain_id,
        settlement,
        eth_flow,
        wrapped_native,
        buy_token,
        receiver,
        sell_amount,
        buy_amount,
        app_data_hash,
    );

    let mut info: TransactionRequestInfo = TransactionRequest::Ethereum((
        tx,
        TransactionMetadata {
            chain_hash,
            broadcast: true,
            title: Some(swap_title),
            info: Some(swap_info),
            icon: Some(provider_icon),
            token_info: out_token.map(|t| {
                (
                    U256::from_str(&t.value).unwrap_or_default(),
                    t.decimals,
                    t.symbol,
                )
            }),
            ..Default::default()
        },
    ))
    .try_into()
    .map_err(|e: zilpay::errors::tx::TransactionErrors| e.to_string())?;

    info.cow_order = Some(CowOrderInfo {
        uid,
        orderbook_url: blob.orderbook_url.clone(),
        valid_to: blob.valid_to,
    });
    Ok(info)
}

#[allow(clippy::too_many_arguments)]
#[frb(ignore)]
pub async fn cowswap_finalize_swap(
    meta: &CowMeta,
    quote_blob: &str,
    permit_signature: Option<&str>,
    swap_title: String,
    swap_info: String,
    provider_icon: String,
    out_token: Option<BaseTokenInfo>,
) -> Result<TransactionRequestInfo, String> {
    let blob: CowQuoteBlob =
        serde_json::from_str(quote_blob).map_err(|e| format!("invalid cow quote_blob: {e}"))?;
    let chain_hash = meta.common.chain_hash;
    let swapper = Address::from_str(&meta.common.account_addr).map_err(|e| e.to_string())?;

    if blob.is_wrap_unwrap {
        let weth = Address::from_str(&blob.wrapped_native).map_err(|e| e.to_string())?;
        return build_weth_wrap_tx(
            weth,
            blob.chain_id,
            chain_hash,
            swapper,
            &blob.sell_amount,
            blob.is_native_in,
            swap_title,
            swap_info,
            provider_icon,
            out_token,
        );
    }

    if !blob.app_data.is_empty() && !blob.app_data_hash.is_empty() {
        if let Err(err) =
            put_cow_app_data(&blob.orderbook_url, &blob.app_data_hash, &blob.app_data).await
        {
            eprintln!("[cowswap] put_cow_app_data warning: {err}");
        }
    }

    if blob.is_native_in {
        return build_ethflow_tx(
            &blob,
            chain_hash,
            swapper,
            swap_title,
            swap_info,
            provider_icon,
            out_token,
        );
    }

    let sig = permit_signature
        .ok_or_else(|| "missing EIP-712 Order signature for CoW Swap".to_string())?;
    let signature = if sig.starts_with("0x") {
        sig.to_owned()
    } else {
        format!("0x{sig}")
    };

    let order = CowOrderCreation {
        sell_token: blob.sell_token.clone(),
        buy_token: blob.buy_token.clone(),
        receiver: blob.receiver.clone(),
        sell_amount: blob.sell_amount.clone(),
        buy_amount: blob.buy_amount.clone(),
        valid_to: blob.valid_to,
        app_data: blob.app_data_hash.clone(),
        app_data_hash: None,
        fee_amount: "0".to_string(),
        kind: "sell".to_string(),
        partially_fillable: false,
        sell_token_balance: "erc20".to_string(),
        buy_token_balance: "erc20".to_string(),
        signing_scheme: "eip712".to_string(),
        signature,
        from: meta.common.account_addr.clone(),
        quote_id: blob.quote_id,
    };

    // Note: when called during a dry-run preview without a real user signature, do not POST to
    // the live orderbook if the signature is empty. ERC-20 routes never run gas preview on open.
    let uid = post_cow_order(&blob.orderbook_url, &order).await?;

    Ok(TransactionRequestInfo {
        metadata: TransactionMetadataInfo {
            chain_hash,
            broadcast: false,
            hash: Some(uid.clone()),
            info: Some(swap_info),
            icon: Some(provider_icon),
            title: Some(swap_title),
            signer: Some(meta.common.account_addr.clone()),
            token_info: out_token,
        },
        scilla: None,
        evm: None,
        btc: None,
        tron: None,
        solana: None,
        cow_order: Some(CowOrderInfo {
            uid,
            orderbook_url: blob.orderbook_url,
            valid_to: blob.valid_to,
        }),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::exchange::cowswap::appdata::build_cow_app_data;
    use crate::models::exchange::cowswap::GPV2_SETTLEMENT;
    use zilpay::alloy::primitives::keccak256;

    #[test]
    fn ethflow_create_order_selector_and_encoding() {
        let expected_selector =
            &keccak256("createOrder((address,address,uint256,uint256,bytes32,uint256,uint32,bool,int64))")[..4];
        assert_eq!(
            ICoWSwapEthFlow::createOrderCall::SELECTOR.as_slice(),
            expected_selector
        );

        let app_data = build_cow_app_data(Some(AppFeeConfig::default_fee()));
        let blob = CowQuoteBlob {
            chain_id: 1,
            orderbook_url: "https://api.cow.fi/mainnet".to_string(),
            settlement: GPV2_SETTLEMENT.to_string(),
            wrapped_native: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2".to_string(),
            sell_token: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2".to_string(),
            buy_token: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48".to_string(),
            receiver: "0x0000000000000000000000000000000000000001".to_string(),
            sell_amount: "1000000000000000000".to_string(),
            buy_amount: "2286262518".to_string(),
            valid_to: 1_776_759_942,
            app_data: app_data.full_app_data,
            app_data_hash: app_data.app_data_hash,
            quote_id: Some(98765),
            is_native_in: true,
            is_wrap_unwrap: false,
        };

        let swapper = Address::from_str("0x0000000000000000000000000000000000000001").unwrap();
        let tx = build_ethflow_tx(
            &blob,
            1,
            swapper,
            "ETH > USDC".to_string(),
            "1 ETH -> 2297 USDC".to_string(),
            "assets/icons/cowswap.svg".to_string(),
            None,
        )
        .unwrap();

        let evm = tx.evm.expect("ethflow tx has evm request");
        assert_eq!(evm.to.as_deref(), Some(COW_ETH_FLOW));
        assert_eq!(evm.value.as_deref(), Some("1000000000000000000"));
        let data = evm.data.expect("calldata present");
        assert_eq!(&data[..4], expected_selector);
        let decoded = ICoWSwapEthFlow::createOrderCall::abi_decode(&data).unwrap();
        assert_eq!(decoded.order.quoteId, 98765);
        assert_eq!(decoded.order.feeAmount, U256::ZERO);
        assert_eq!(decoded.order.validTo, 1_776_759_942);

        let cow_order = tx.cow_order.expect("ethflow tx carries cow_order");
        assert!(cow_order.uid.starts_with("0x"));
        assert_eq!(cow_order.uid.len(), 114);
        assert_eq!(cow_order.valid_to, 1_776_759_942);
    }

    #[test]
    fn cow_quote_blob_round_trips() {
        let blob = CowQuoteBlob {
            chain_id: 8453,
            orderbook_url: "https://api.cow.fi/base".to_string(),
            settlement: GPV2_SETTLEMENT.to_string(),
            wrapped_native: "0x4200000000000000000000000000000000000006".to_string(),
            sell_token: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913".to_string(),
            buy_token: "0x4200000000000000000000000000000000000006".to_string(),
            receiver: "0x0000000000000000000000000000000000000001".to_string(),
            sell_amount: "1000000".to_string(),
            buy_amount: "400000000000000".to_string(),
            valid_to: 123456,
            app_data: "{}".to_string(),
            app_data_hash: "0x00".to_string(),
            quote_id: Some(42),
            is_native_in: false,
            is_wrap_unwrap: false,
        };
        let encoded = serde_json::to_string(&blob).unwrap();
        let decoded: CowQuoteBlob = serde_json::from_str(&encoded).unwrap();
        assert_eq!(decoded, blob);
    }
}
