use crate::{
    models::ftoken::FTokenInfo,
    service::service::BACKGROUND_SERVICE,
    utils::{
        errors::ServiceError,
        utils::{parse_address, with_service},
    },
};
use std::sync::Arc;
pub use zilpay::background::{bg_rates::RatesManagement, bg_token::TokensManagement};
pub use zilpay::proto::address::Address;
use zilpay::{
    background::bg_wallet::WalletManagement,
    token::ft::FToken,
    token_quotes::{
        bnb_tokens::pancakeswap_get_tokens, coingecko_tokens::coingecko_get_tokens,
        zilliqa_tokens::zilpay_get_tokens,
    },
    wallet::{wallet_storage::StorageOperations, wallet_token::TokenManagement},
};

pub async fn sync_balances(wallet_index: usize) -> Result<(), String> {
    if let Some(service) = BACKGROUND_SERVICE.read().await.as_ref() {
        let core = Arc::clone(&service.core);

        core.sync_ftokens_balances(wallet_index)
            .await
            .map_err(ServiceError::BackgroundError)?;

        Ok(())
    } else {
        Err(ServiceError::NotRunning.to_string())
    }
}

pub async fn update_rates(wallet_index: usize) -> Result<(), String> {
    if let Some(service) = BACKGROUND_SERVICE.read().await.as_ref() {
        let core = Arc::clone(&service.core);

        core.update_rates(wallet_index)
            .await
            .map_err(ServiceError::BackgroundError)?;

        Ok(())
    } else {
        Err(ServiceError::NotRunning.to_string())
    }
}

pub async fn fetch_token_meta(addr: String, wallet_index: usize) -> Result<FTokenInfo, String> {
    if let Some(service) = BACKGROUND_SERVICE.read().await.as_ref() {
        let core = Arc::clone(&service.core);
        let address = parse_address(addr)?;

        let token_meta = core
            .fetch_ftoken_meta(wallet_index, address)
            .await
            .map_err(ServiceError::BackgroundError)?;

        Ok(token_meta.into())
    } else {
        Err(ServiceError::NotRunning.to_string())
    }
}

pub async fn fetch_tokens_list_zilliqa_legacy(
    limit: u32,
    offset: u32,
) -> Result<Vec<FTokenInfo>, String> {
    let tokens = zilpay_get_tokens(limit, offset)
        .await
        .map_err(|e| e.to_string())?;

    Ok(tokens
        .into_iter()
        .map(From::from)
        .collect::<Vec<FTokenInfo>>())
}

pub async fn fetch_tokens_evm_list(
    chain_name: String,
    chain_id: u16,
) -> Result<Vec<FTokenInfo>, String> {
    let tokens = match chain_id {
        56 => pancakeswap_get_tokens().await.map_err(|e| e.to_string())?,
        _ => coingecko_get_tokens(&chain_name)
            .await
            .map_err(|e| e.to_string())?,
    };

    Ok(tokens
        .into_iter()
        .map(From::from)
        .collect::<Vec<FTokenInfo>>())
}

pub async fn add_ftoken(meta: FTokenInfo, wallet_index: usize) -> Result<Vec<FTokenInfo>, String> {
    with_service(|core| {
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let token: FToken = meta.try_into()?;

        wallet
            .add_ftoken(token)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        let ftokens = wallet
            .get_ftokens()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?
            .into_iter()
            .map(|t| t.into())
            .collect();

        Ok(ftokens)
    })
    .await
    .map_err(Into::into)
}

pub async fn rm_ftoken(wallet_index: usize, token_address: String) -> Result<(), String> {
    with_service(|core| {
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let ftokens = wallet
            .get_ftokens()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        let mb_token_index = ftokens
            .iter()
            .position(|ftoken| ftoken.addr.auto_format() == token_address);

        if let Some(token_index) = mb_token_index {
            wallet
                .remove_ftoken(token_index)
                .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        }

        Ok(())
    })
    .await
    .map_err(Into::into)
}
