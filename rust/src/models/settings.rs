pub use zilpay::cipher::options::CipherOrders;
pub use zilpay::config::sha::SHA256_SIZE;
pub use zilpay::errors::settings::SettingsErrors;
pub use zilpay::settings::argon2::ArgonParams;
pub use zilpay::settings::wallet_settings::WalletSettings;
use zilpay::{
    errors::cipher::CipherErrors,
    settings::{
        browser::{BrowserSettings, ContentBlockingLevel},
        wallet_settings::{NetworkSettings, WalletFeatures},
    },
    token_quotes::TokenQuotesAPIOptions,
};

#[derive(Debug, Clone, PartialEq)]
pub struct WalletArgonParamsInfo {
    pub memory: u32,
    pub iterations: u32,
    pub threads: u32,
    pub secret: String,
}

impl From<ArgonParams> for WalletArgonParamsInfo {
    fn from(value: ArgonParams) -> Self {
        WalletArgonParamsInfo {
            memory: value.memory,
            iterations: value.iterations,
            threads: value.threads,
            secret: hex::encode(value.secret),
        }
    }
}

impl TryFrom<WalletArgonParamsInfo> for ArgonParams {
    type Error = SettingsErrors;

    fn try_from(value: WalletArgonParamsInfo) -> Result<Self, Self::Error> {
        let secret: [u8; SHA256_SIZE] = match hex::decode(&value.secret) {
            Ok(hex) => hex
                .try_into()
                .unwrap_or(ArgonParams::hash_secret(&value.secret)),
            Err(_) => ArgonParams::hash_secret(&value.secret),
        };

        Ok(Self {
            secret,
            memory: value.memory,
            iterations: value.iterations,
            threads: value.threads,
        })
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct WalletSettingsInfo {
    pub cipher_orders: Vec<u8>,
    pub argon_params: WalletArgonParamsInfo,
    pub currency_convert: String,
    pub ipfs_node: Option<String>,
    pub ens_enabled: bool,
    pub tokens_list_fetcher: bool,
    pub node_ranking_enabled: bool,
    pub max_connections: u8,
    pub request_timeout_secs: u32,
    pub rates_api_options: u8,
}

impl From<WalletSettings> for WalletSettingsInfo {
    fn from(value: WalletSettings) -> Self {
        WalletSettingsInfo {
            argon_params: value.argon_params.into(),
            cipher_orders: value.cipher_orders.iter().map(|v| v.code()).collect(),
            currency_convert: value.features.currency_convert,
            ipfs_node: value.features.ipfs_node,
            ens_enabled: value.features.ens_enabled,
            tokens_list_fetcher: value.network.tokens_list_fetcher,
            node_ranking_enabled: value.network.node_ranking_enabled,
            max_connections: value.network.max_connections,
            request_timeout_secs: value.network.request_timeout_secs,
            rates_api_options: value.rates_api_options.code(),
        }
    }
}

impl TryFrom<WalletSettingsInfo> for WalletSettings {
    type Error = SettingsErrors;

    fn try_from(value: WalletSettingsInfo) -> Result<Self, Self::Error> {
        Ok(Self {
            rates_api_options: TokenQuotesAPIOptions::from_code(value.rates_api_options),
            cipher_orders: value
                .cipher_orders
                .iter()
                .map(|v| CipherOrders::from_code(*v))
                .collect::<Result<Vec<CipherOrders>, CipherErrors>>()?,
            argon_params: value.argon_params.try_into()?,
            features: WalletFeatures {
                currency_convert: value.currency_convert,
                ens_enabled: value.ens_enabled,
                ipfs_node: value.ipfs_node,
            },
            network: NetworkSettings {
                tokens_list_fetcher: value.tokens_list_fetcher,
                node_ranking_enabled: value.node_ranking_enabled,
                max_connections: value.max_connections,
                request_timeout_secs: value.request_timeout_secs,
            },
        })
    }
}

pub struct BrowserSettingsInfo {
    pub search_engine_index: u8,

    pub cache_enabled: bool,
    pub cookies_enabled: bool,
    pub content_blocking: u8,

    pub do_not_track: bool,
    pub incognito_mode: bool,
    pub text_scaling_factor: f32,

    pub allow_geolocation: bool,
    pub allow_camera: bool,
    pub allow_microphone: bool,
    pub allow_auto_play: bool,
}

impl From<BrowserSettings> for BrowserSettingsInfo {
    fn from(value: BrowserSettings) -> Self {
        BrowserSettingsInfo {
            search_engine_index: value.search_engine_index,
            cache_enabled: value.cache_enabled,
            cookies_enabled: value.cookies_enabled,
            content_blocking: value.content_blocking.code(),
            do_not_track: value.do_not_track,
            incognito_mode: value.incognito_mode,
            text_scaling_factor: value.text_scaling_factor,
            allow_geolocation: value.allow_geolocation,
            allow_camera: value.allow_camera,
            allow_microphone: value.allow_microphone,
            allow_auto_play: value.allow_auto_play,
        }
    }
}

impl From<BrowserSettingsInfo> for BrowserSettings {
    fn from(value: BrowserSettingsInfo) -> Self {
        BrowserSettings {
            search_engine_index: value.search_engine_index,
            cache_enabled: value.cache_enabled,
            cookies_enabled: value.cookies_enabled,
            content_blocking: ContentBlockingLevel::from_code(value.content_blocking),
            do_not_track: value.do_not_track,
            incognito_mode: value.incognito_mode,
            text_scaling_factor: value.text_scaling_factor,
            allow_geolocation: value.allow_geolocation,
            allow_camera: value.allow_camera,
            allow_microphone: value.allow_microphone,
            allow_auto_play: value.allow_auto_play,
        }
    }
}
