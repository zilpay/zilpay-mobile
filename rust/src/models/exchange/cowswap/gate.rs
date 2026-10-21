//! Eager (load-time) support gate for CoW Swap (`EagerGate::Cow`).
//!
//! CoW Protocol settles intents via solver competition across all major DEXs on supported EVM
//! chains, so pool liquidity is decided lazily at quote time (`POST /api/v1/quote`). At load time
//! the eager gate strips any asset whose chain is not a supported CoW chain or whose token address
//! is neither native nor a valid 20-byte EVM address (`Address::from_str`).

use std::str::FromStr;

use flutter_rust_bridge::frb;
use zilpay::alloy::primitives::Address;

use crate::models::exchange::cowswap::is_supported_chain;
use crate::models::exchange::{ExchangeAsset, ExchangeProvider};

#[frb(ignore)]
pub(in crate::models::exchange) async fn evaluate_support_eager(
    assets: &[ExchangeAsset],
) -> Vec<usize> {
    assets
        .iter()
        .enumerate()
        .filter_map(|(idx, asset)| {
            let meta = asset.providers.iter().find_map(|p| match p {
                ExchangeProvider::CowSwap(m) => Some(m),
                ExchangeProvider::Relay(_)
                | ExchangeProvider::Uniswap(_)
                | ExchangeProvider::PancakeSwap(_)
                | ExchangeProvider::PlunderSwap(_)
                | ExchangeProvider::ZilSwap(_)
                | ExchangeProvider::SunSwap(_) => None,
            })?;
            let valid_chain = is_supported_chain(meta.common.chain_id);
            let valid_token = asset.token.addr_type == 1
                && (asset.token.native || Address::from_str(&asset.token.addr).is_ok());
            (!(valid_chain && valid_token)).then_some(idx)
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::exchange::cowswap::CowMeta;
    use crate::models::ftoken::FTokenInfo;
    use std::collections::{HashMap, HashSet};
    use zilpay::tokio;

    fn dummy_asset(chain_id: u64, addr: &str, native: bool, addr_type: u8) -> ExchangeAsset {
        let mut providers = HashSet::new();
        if let Some(meta) = CowMeta::for_chain(
            1,
            chain_id,
            60,
            "0x0000000000000000000000000000000000000001",
        ) {
            providers.insert(ExchangeProvider::CowSwap(meta));
        }
        ExchangeAsset {
            token: FTokenInfo {
                name: "Test".to_string(),
                symbol: "TST".to_string(),
                decimals: 18,
                addr: addr.to_string(),
                addr_type,
                logo: None,
                balances: HashMap::new(),
                rate: 0.0,
                default: false,
                native,
                chain_hash: 1,
            },
            providers,
            halted: false,
        }
    }

    #[zilpay::tokio::test]
    async fn gate_keeps_valid_cow_assets_and_prunes_invalid_address() {
        let valid_erc20 = dummy_asset(
            1,
            "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            false,
            1,
        );
        let valid_native = dummy_asset(
            1,
            "0x0000000000000000000000000000000000000000",
            true,
            1,
        );
        let invalid_erc20 = dummy_asset(1, "not-an-evm-address", false, 1);

        let dead = evaluate_support_eager(&[valid_erc20, valid_native, invalid_erc20]).await;
        assert_eq!(dead, vec![2]);
    }
}
