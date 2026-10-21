pub mod bootstrap;
pub(crate) mod btc;
mod evm;
pub mod ledger;
mod svm;
pub(crate) mod tron;
mod zil;

pub use bootstrap::{bootstrap_exchange_providers, validate_exchange_providers, refresh_exchange_quotes};
pub use ledger::{
    check_exchange_approval, estimate_swap_base_nonce, finalize_exchange_swap,
    prepare_exchange_swap, PreparedSwapInfo,
};

use flutter_rust_bridge::frb;
use zilpay::background::bg_tx::TransactionsManagement;
use zilpay::secrecy::SecretString;

use crate::api::transaction::unlock_seed;
use crate::frb_generated::StreamSink;
use crate::models::exchange::cowswap::{
    delete_cow_order, fetch_cow_order_status, order::order_cancellation_typed_data_json,
};
use crate::models::exchange::relay::RelayOrigin;
use crate::models::exchange::{ExchangeProvider, ExchangeTxDisplay, SwapAuth, SwapParams};
use crate::models::transactions::history::HistoricalTransactionInfo;
use crate::utils::{errors::ServiceError, helpers::handle};

pub async fn get_cow_order_status(orderbook_url: String, uid: String) -> Result<String, String> {
    fetch_cow_order_status(&orderbook_url, &uid).await
}

#[frb(sync)]
pub fn prepare_cow_order_cancellation(
    chain_id: u64,
    settlement: String,
    order_uid: String,
) -> String {
    order_cancellation_typed_data_json(chain_id, &settlement, &order_uid)
}

pub async fn submit_cow_order_cancellation(
    orderbook_url: String,
    uid: String,
    signature: String,
) -> Result<(), String> {
    delete_cow_order(&orderbook_url, &uid, &signature).await
}

pub async fn cancel_cow_order_software(
    auth: SwapAuth,
    chain_id: u64,
    settlement: String,
    orderbook_url: String,
    uid: String,
) -> Result<(), String> {
    let core = handle()?;
    let seed = unlock_seed(&core, auth.wallet_index, auth.password).await?;
    let secret_passphrase = SecretString::new(auth.passphrase.unwrap_or_default().into());
    let typed_data = order_cancellation_typed_data_json(chain_id, &settlement, &uid);

    let (_, sig) = core
        .sign_typed_data_eip712(
            auth.wallet_index,
            auth.account_index,
            &seed,
            &secret_passphrase,
            &typed_data,
            Some("Cancel CoW Swap Order".to_string()),
            Some("assets/icons/cowswap.svg".to_string()),
        )
        .await
        .map_err(ServiceError::BackgroundError)?;

    let sig_hex = sig.to_hex_prefixed();
    delete_cow_order(&orderbook_url, &uid, &sig_hex).await
}

pub async fn execute_exchange_swap(
    auth: SwapAuth,
    params: SwapParams,
    display: ExchangeTxDisplay,
    sink: StreamSink<String>,
) -> Result<Vec<HistoricalTransactionInfo>, String> {
    let result = match &params.provider {
        ExchangeProvider::Relay(_) => {
            match RelayOrigin::from_addr_type(params.from.token.addr_type) {
                Some(RelayOrigin::Svm) => {
                    svm::execute_svm_exchange_swap(auth, params, display, &sink).await
                }
                Some(RelayOrigin::Btc) => {
                    btc::execute_btc_exchange_swap(auth, params, display, &sink).await
                }
                Some(RelayOrigin::Tron) => {
                    tron::execute_tron_exchange_swap(auth, params, display, &sink).await
                }
                Some(RelayOrigin::Evm) | None => {
                    evm::execute_evm_exchange_swap(auth, params, display, &sink).await
                }
            }
        }
        ExchangeProvider::SunSwap(_) => {
            tron::execute_tron_exchange_swap(auth, params, display, &sink).await
        }
        ExchangeProvider::ZilSwap(_) => {
            zil::execute_zil_exchange_swap(auth, params, display, &sink).await
        }
        ExchangeProvider::Uniswap(_)
        | ExchangeProvider::PancakeSwap(_)
        | ExchangeProvider::PlunderSwap(_)
        | ExchangeProvider::CowSwap(_) => {
            evm::execute_evm_exchange_swap(auth, params, display, &sink).await
        }
    };

    match result {
        Ok(history) => Ok(history),
        Err(err) => {
            let _ = sink.add(format!("error:{err}"));
            Ok(Vec::new())
        }
    }
}
