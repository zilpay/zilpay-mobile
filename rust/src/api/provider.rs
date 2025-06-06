use crate::{
    models::provider::NetworkConfigInfo,
    service::service::BACKGROUND_SERVICE,
    utils::{errors::ServiceError, utils::with_service},
};
use serde_json::Value;
pub use zilpay::settings::{
    notifications::NotificationState,
    theme::{Appearances, Theme},
};
use zilpay::{background::bg_provider::ProvidersManagement, network::provider::NetworkProvider};
pub use zilpay::{
    background::bg_settings::SettingsManagement, wallet::wallet_storage::StorageOperations,
};

pub async fn get_providers() -> Result<Vec<NetworkConfigInfo>, String> {
    with_service(|core| {
        let providers = core.get_providers();

        Ok(providers
            .into_iter()
            .map(|p| p.config.into())
            .collect::<Vec<NetworkConfigInfo>>())
    })
    .await
    .map_err(Into::into)
}

pub async fn get_provider(chain_hash: u64) -> Result<NetworkConfigInfo, String> {
    with_service(|core| {
        let provider = core.get_provider(chain_hash)?;

        Ok(provider.config.into())
    })
    .await
    .map_err(Into::into)
}

pub async fn provider_req_proxy(payload: String, chain_hash: u64) -> Result<String, String> {
    let guard = BACKGROUND_SERVICE.read().await;
    let service = guard.as_ref().ok_or(ServiceError::NotRunning)?;
    let provider = service
        .core
        .get_provider(chain_hash)
        .map_err(ServiceError::BackgroundError)?;

    let res = provider
        .proxy_req(payload)
        .await
        .map_err(ServiceError::NetworkErrors)?;

    Ok(res.to_string())
}

pub async fn add_provider(provider_config: NetworkConfigInfo) -> Result<u64, String> {
    with_service(|core| {
        let config = provider_config.try_into()?;
        let hash = core.add_provider(config)?;

        Ok(hash)
    })
    .await
    .map_err(Into::into)
}

pub async fn remove_provider(provider_index: u16) -> Result<(), String> {
    with_service(|core| {
        core.remvoe_provider(provider_index as usize)?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn add_providers_list(provider_config: Vec<NetworkConfigInfo>) -> Result<(), String> {
    with_service(|core| {
        let mut providers = core.get_providers();

        for new_provider in &provider_config {
            providers.retain(|p| p.config.chain_id() != new_provider.chain_id);
        }

        for new_conf in provider_config {
            let new_provider = NetworkProvider::new(new_conf.try_into()?);

            providers.push(new_provider);
        }

        core.update_providers(providers)?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn create_or_update_chain(provider_config: NetworkConfigInfo) -> Result<(), String> {
    with_service(|core| {
        let mut new_chain = provider_config;

        new_chain.ftokens.iter_mut().for_each(|t| {
            t.chain_hash = new_chain.chain_hash;
        });

        let mut providers = core.get_providers();
        let existing_provider_index = providers
            .iter()
            .position(|p| p.config.hash() == new_chain.chain_hash);

        match existing_provider_index {
            Some(index) => {
                providers[index].config = new_chain.try_into()?;
                core.update_providers(providers)?;
            }
            None => {
                core.add_provider(new_chain.try_into()?)?;
            }
        }

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn select_accounts_chain(wallet_index: usize, chain_hash: u64) -> Result<(), String> {
    with_service(|core| {
        core.select_accounts_chain(wallet_index, chain_hash)
            .map_err(ServiceError::BackgroundError)
    })
    .await
    .map_err(Into::into)
}

pub fn get_chains_providers_from_json(json_str: String) -> Result<Vec<NetworkConfigInfo>, String> {
    let json_value_list: Value = serde_json::from_str(&json_str).map_err(|e| e.to_string())?;

    let chains = json_value_list
        .as_array()
        .ok_or(ServiceError::SerdeSerror("json shoud be array".to_string()))?
        .into_iter()
        .map(|chain| NetworkConfigInfo::from_json_value(chain))
        .collect::<Result<Vec<NetworkConfigInfo>, ServiceError>>()?;

    Ok(chains)
}
