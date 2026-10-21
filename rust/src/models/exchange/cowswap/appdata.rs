//! Canonical CoW Protocol `appData` v1.15.0 builder and `keccak256` hash helper.
//!
//! CoW's `@cowprotocol/app-data` SDK serializes `appData` with deterministic sorted keys and no
//! whitespace before hashing with `keccak256`. Any whitespace or key-order difference changes
//! `appDataHash` and causes `POST /api/v1/orders` to reject the order with `AppDataHashMismatch`.

use flutter_rust_bridge::frb;
use zilpay::alloy::hex;
use zilpay::alloy::primitives::{keccak256, B256};

use crate::models::exchange::AppFeeConfig;

pub const COW_APP_CODE: &str = "bearby";
pub const COW_APP_DATA_VERSION: &str = "1.15.0";

/// Built `appData` pair: canonical minified JSON string and its `0x`-prefixed `keccak256` digest.
#[frb(ignore)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CowAppData {
    pub full_app_data: String,
    pub app_data_hash: String,
    pub hash_bytes: B256,
}

/// Build the canonical CoW `appData` JSON (v1.15.0) and its `keccak256` hash.
///
/// Keys at every object level are sorted lexicographically with zero whitespace, matching
/// `json-stringify-deterministic` used by `@cowprotocol/app-data`:
/// - Root keys: `"appCode"`, `"metadata"`, `"version"`
/// - `metadata` keys: `"partnerFee"` (when `fee.bps > 0`), `"widget"`
/// - `partnerFee` keys: `"recipient"`, `"volumeBps"`
/// - `widget` keys: `"appCode"`
#[frb(ignore)]
pub fn build_cow_app_data(fee: Option<AppFeeConfig>) -> CowAppData {
    let full_app_data = match fee.filter(|f| f.bps > 0 && !f.recipient.is_empty()) {
        Some(f) => format!(
            r#"{{"appCode":"{app}","metadata":{{"partnerFee":{{"recipient":"{recipient}","volumeBps":{bps}}},"widget":{{"appCode":"{app}"}}}},"version":"{ver}"}}"#,
            app = COW_APP_CODE,
            recipient = f.recipient,
            bps = f.bps,
            ver = COW_APP_DATA_VERSION,
        ),
        None => format!(
            r#"{{"appCode":"{app}","metadata":{{"widget":{{"appCode":"{app}"}}}},"version":"{ver}"}}"#,
            app = COW_APP_CODE,
            ver = COW_APP_DATA_VERSION,
        ),
    };

    let hash_bytes = keccak256(full_app_data.as_bytes());
    let app_data_hash = hex::encode_prefixed(hash_bytes);

    CowAppData {
        full_app_data,
        app_data_hash,
        hash_bytes,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn default_bearby_app_data_matches_cow_sdk_deterministic_hash() {
        let app_data = build_cow_app_data(Some(AppFeeConfig::default_fee()));
        assert_eq!(
            app_data.full_app_data,
            r#"{"appCode":"bearby","metadata":{"partnerFee":{"recipient":"0x74d35b31ed6b31818331bc28fe343669126f152f","volumeBps":100},"widget":{"appCode":"bearby"}},"version":"1.15.0"}"#
        );
        assert_eq!(
            app_data.app_data_hash,
            "0xef273142aba844c67fcc312fc8110f99a44196a84e0bf2d1a065d1b190f3db91"
        );
    }

    #[test]
    fn no_fee_app_data_omits_partner_fee_key() {
        let app_data = build_cow_app_data(None);
        assert_eq!(
            app_data.full_app_data,
            r#"{"appCode":"bearby","metadata":{"widget":{"appCode":"bearby"}},"version":"1.15.0"}"#
        );
        assert!(app_data.app_data_hash.starts_with("0x"));
        assert_eq!(app_data.app_data_hash.len(), 66);
    }
}
