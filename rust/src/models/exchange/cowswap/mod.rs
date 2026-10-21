//! CoW Protocol (CoW Swap) intent/solver DEX aggregator provider (`GPv2Settlement` + `CoWSwapEthFlow`).

pub mod appdata;
pub mod gate;
pub mod order;
pub mod tx;

use std::borrow::Cow;
use std::str::FromStr;

use flutter_rust_bridge::frb;
use zilpay::alloy::hex;
use zilpay::alloy::primitives::Address;

use super::univ_router::NATIVE_SENTINEL;
use super::{ExchangeAsset, ProviderCommon, ProviderQuote};

pub use tx::{
    cowswap_check_approval, cowswap_finalize_swap, cowswap_prepare_swap, cowswap_quote_info,
    delete_cow_order, fetch_cow_order_status,
};

pub const GPV2_SETTLEMENT: &str = "0x9008D19f58AAbD9eD0D60971565AA8510560ab41";
pub const GPV2_VAULT_RELAYER: &str = "0xC92E8bdf79f0507f65a392b0ab4667716BFE0110";
pub const COW_ETH_FLOW: &str = "0xbA3cB449bD2B4ADddBc894D8697F5170800EAdeC";
pub const COW_NATIVE_BUY_TOKEN: &str = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";

/// Supported CoW Protocol chains (`chain_id`, `orderbook_url`, `wrapped_native_token`).
const SUPPORTED_COW_CHAINS: &[(u64, &str, &str)] = &[
    (
        1,
        "https://api.cow.fi/mainnet",
        "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    ),
    (
        56,
        "https://api.cow.fi/bnb",
        "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
    ),
    (
        100,
        "https://api.cow.fi/xdai",
        "0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d",
    ),
    (
        137,
        "https://api.cow.fi/polygon",
        "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270",
    ),
    (
        8453,
        "https://api.cow.fi/base",
        "0x4200000000000000000000000000000000000006",
    ),
    (
        42161,
        "https://api.cow.fi/arbitrum_one",
        "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1",
    ),
    (
        43114,
        "https://api.cow.fi/avalanche",
        "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7",
    ),
    (
        11_155_111,
        "https://api.cow.fi/sepolia",
        "0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14",
    ),
];

#[derive(Debug, Clone, Copy)]
pub struct CowCfg {
    pub default_slippage_bps: u32,
    pub supports_price_protection: bool,
}

impl CowCfg {
    #[frb(ignore)]
    pub const fn default() -> Self {
        Self {
            default_slippage_bps: 50,
            supports_price_protection: true,
        }
    }
}

#[derive(Debug, Clone)]
pub struct CowMeta {
    pub common: ProviderCommon,
    pub cfg: CowCfg,
    pub orderbook_url: String,
    pub settlement: String,
    pub vault_relayer: String,
    pub domain_separator: String,
    pub quote: Option<ProviderQuote>,
}

impl CowMeta {
    #[frb(ignore)]
    pub fn for_chain(
        chain_hash: u64,
        chain_id: u64,
        slip44: u32,
        account_addr: &str,
    ) -> Option<Self> {
        let orderbook_url = orderbook_url_for_chain(chain_id)?;
        let settlement_addr = Address::from_str(GPV2_SETTLEMENT).ok()?;
        let domain_sep = order::domain_separator(chain_id, settlement_addr);

        Some(Self {
            common: ProviderCommon {
                chain_hash,
                chain_id,
                slip44,
                account_addr: account_addr.to_owned(),
                icon_asset: "assets/icons/cowswap.svg".to_owned(),
                display_name: "CoW Swap".to_owned(),
            },
            cfg: CowCfg::default(),
            orderbook_url: orderbook_url.to_owned(),
            settlement: GPV2_SETTLEMENT.to_owned(),
            vault_relayer: GPV2_VAULT_RELAYER.to_owned(),
            domain_separator: hex::encode_prefixed(domain_sep),
            quote: None,
        })
    }
}

#[frb(ignore)]
pub fn is_supported_chain(chain_id: u64) -> bool {
    SUPPORTED_COW_CHAINS
        .iter()
        .any(|(id, _, _)| *id == chain_id)
}

#[frb(ignore)]
pub fn orderbook_url_for_chain(chain_id: u64) -> Option<&'static str> {
    SUPPORTED_COW_CHAINS
        .iter()
        .find_map(|(id, url, _)| (*id == chain_id).then_some(*url))
}

#[frb(ignore)]
pub fn wrapped_native_for_chain(chain_id: u64) -> Option<&'static str> {
    SUPPORTED_COW_CHAINS
        .iter()
        .find_map(|(id, _, weth)| (*id == chain_id).then_some(*weth))
}

fn strip_chain_prefix(raw: &str, expected_chain_id: u64) -> Result<&str, String> {
    match raw.split_once(':') {
        Some((chain_str, addr)) => {
            let cid: u64 = chain_str
                .parse()
                .map_err(|_| format!("invalid chain prefix in {raw}"))?;
            if cid != expected_chain_id {
                return Err("cross-chain swap not supported".to_string());
            }
            Ok(addr)
        }
        None => Ok(raw),
    }
}

fn is_native_token_addr(addr: &str) -> bool {
    addr.eq_ignore_ascii_case(NATIVE_SENTINEL) || addr.eq_ignore_ascii_case(COW_NATIVE_BUY_TOKEN)
}

/// Resolve the `sellToken` address for CoW `/api/v1/quote`:
/// - Native input (EthFlow) quotes against the chain's wrapped native token (`WETH` / `WBNB` / `WMATIC` / `WXDAI` / `WAVAX`).
/// - ERC-20 input uses the token's contract address directly.
#[frb(ignore)]
pub fn resolve_sell_token(
    chain_id: u64,
    is_native_in: bool,
    from_asset: &str,
) -> Result<Cow<'static, str>, String> {
    let weth = wrapped_native_for_chain(chain_id)
        .ok_or_else(|| format!("unsupported CoW chain {chain_id}"))?;
    let stripped = strip_chain_prefix(from_asset, chain_id)?;
    if is_native_in || is_native_token_addr(stripped) {
        Ok(Cow::Borrowed(weth))
    } else {
        Ok(Cow::Owned(stripped.to_owned()))
    }
}

/// Resolve the `buyToken` address for CoW `/api/v1/quote`:
/// - Native output uses CoW's native buy sentinel `0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE`
///   (`GPv2Settlement` unwraps WETH and transfers native coin directly to `receiver`).
/// - ERC-20 output uses the token's contract address directly.
#[frb(ignore)]
pub fn resolve_buy_token(is_native_out: bool, to_asset: &str) -> Result<Cow<'static, str>, String> {
    let stripped = to_asset
        .split_once(':')
        .map(|(_, addr)| addr)
        .unwrap_or(to_asset);
    if is_native_out || is_native_token_addr(stripped) {
        Ok(Cow::Borrowed(COW_NATIVE_BUY_TOKEN))
    } else {
        Ok(Cow::Owned(stripped.to_owned()))
    }
}

/// Detect whether the pair is a direct 1:1 native ↔ wrapped-native wrap or unwrap on the same chain.
#[frb(ignore)]
pub fn is_wrap_unwrap(
    meta: &CowMeta,
    from: &ExchangeAsset,
    to: &ExchangeAsset,
    from_asset: &str,
    to_asset: &str,
) -> Result<bool, String> {
    if from.token.chain_hash != to.token.chain_hash {
        return Ok(false);
    }
    let chain_id = meta.common.chain_id;
    let Some(weth) = wrapped_native_for_chain(chain_id) else {
        return Ok(false);
    };
    let in_addr = strip_chain_prefix(from_asset, chain_id)?;
    let out_addr = strip_chain_prefix(to_asset, chain_id)?;
    let is_in_native = from.token.native || is_native_token_addr(in_addr);
    let is_out_native = to.token.native || is_native_token_addr(out_addr);

    let is_wrap = is_in_native && out_addr.eq_ignore_ascii_case(weth);
    let is_unwrap = !is_in_native && in_addr.eq_ignore_ascii_case(weth) && is_out_native;
    Ok(is_wrap || is_unwrap)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn supported_cow_chains_and_excluded_chains() {
        for cid in [1u64, 56, 100, 137, 8453, 42161, 43114, 11_155_111] {
            assert!(is_supported_chain(cid), "expected chain {cid} to be supported");
            let meta = CowMeta::for_chain(
                100 + cid,
                cid,
                60,
                "0x0000000000000000000000000000000000000001",
            )
            .expect("meta for supported chain");
            assert_eq!(meta.common.chain_id, cid);
            assert_eq!(meta.settlement, GPV2_SETTLEMENT);
            assert_eq!(meta.vault_relayer, GPV2_VAULT_RELAYER);
            assert!(meta.domain_separator.starts_with("0x"));
            assert_eq!(meta.domain_separator.len(), 66);
        }

        // Optimism (10) and Zilliqa EVM (32769) are not supported by CoW Orderbook API.
        assert!(!is_supported_chain(10));
        assert!(!is_supported_chain(32769));
        assert!(CowMeta::for_chain(
            1,
            10,
            60,
            "0x0000000000000000000000000000000000000001"
        )
        .is_none());
    }

    #[test]
    fn resolve_tokens_handles_native_and_erc20() {
        let sell_native = resolve_sell_token(1, true, NATIVE_SENTINEL).unwrap();
        assert_eq!(
            sell_native.as_ref(),
            "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
        );

        let sell_erc20 =
            resolve_sell_token(1, false, "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48").unwrap();
        assert_eq!(
            sell_erc20.as_ref(),
            "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
        );

        let buy_native = resolve_buy_token(true, NATIVE_SENTINEL).unwrap();
        assert_eq!(buy_native.as_ref(), COW_NATIVE_BUY_TOKEN);

        let buy_erc20 =
            resolve_buy_token(false, "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48").unwrap();
        assert_eq!(
            buy_erc20.as_ref(),
            "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
        );
    }
}
