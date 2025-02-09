use zilpay::proto::address::Address;
pub use zilpay::{
    errors::network::NetworkErrors,
    rpc::network_config::{ChainConfig, Explorer},
};

pub struct ExplorerInfo {
    pub name: String,
    pub url: String,
    pub icon: Option<String>,
    pub standard: u16,
}

pub struct NetworkConfigInfo {
    pub name: String,
    pub chain: String,
    pub short_name: String,
    pub rpc: Vec<String>,
    pub features: Vec<u16>,
    pub chain_id: u64,
    pub chain_ids: Option<Vec<u8>>,
    pub slip_44: u32,
    pub chain_hash: u64,
    pub ens: Option<String>,
    pub explorers: Vec<ExplorerInfo>,
    pub fallback_enabled: bool,
    pub testnet: Option<bool>,
}

impl From<ExplorerInfo> for Explorer {
    fn from(value: ExplorerInfo) -> Self {
        Explorer {
            name: value.name,
            url: value.url,
            icon: value.icon,
            standard: value.standard,
        }
    }
}

impl From<Explorer> for ExplorerInfo {
    fn from(value: Explorer) -> Self {
        Self {
            name: value.name,
            url: value.url,
            icon: value.icon,
            standard: value.standard,
        }
    }
}

impl From<ChainConfig> for NetworkConfigInfo {
    fn from(value: ChainConfig) -> Self {
        let chain_hash = value.hash();
        let explorers = value
            .explorers
            .into_iter()
            .map(ExplorerInfo::from)
            .collect();

        Self {
            testnet: value.testnet,
            chain_hash,
            name: value.name,
            chain: value.chain,
            short_name: value.short_name,
            chain_ids: value.chain_ids,
            rpc: value.rpc,
            features: value.features,
            chain_id: value.chain_id,
            slip_44: value.slip_44,
            ens: value.ens.map(|a| a.auto_format()),
            explorers,
            fallback_enabled: value.fallback_enabled,
        }
    }
}

impl From<NetworkConfigInfo> for ChainConfig {
    fn from(value: NetworkConfigInfo) -> Self {
        let explorers = value.explorers.into_iter().map(Explorer::from).collect();
        let ens = value.ens.and_then(|a| Address::from_str_hex(&a).ok());

        ChainConfig {
            testnet: value.testnet,
            name: value.name,
            chain: value.chain,
            short_name: value.short_name,
            chain_ids: value.chain_ids,
            rpc: value.rpc,
            features: value.features,
            chain_id: value.chain_id,
            slip_44: value.slip_44,
            ens,
            explorers,
            fallback_enabled: value.fallback_enabled,
        }
    }
}
