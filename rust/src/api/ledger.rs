use zilpay::{
    background::bg_provider::ProvidersManagement, wallet::wallet_storage::StorageOperations,
};
pub use zilpay::{
    background::{bg_wallet::WalletManagement, BackgroundLedgerParams},
    settings::wallet_settings::WalletSettings,
    wallet::wallet_account::AccountManagement,
};
pub use zilpay::{errors::token::TokenError, token::ft::FToken};
pub use zilpay::{proto::pubkey::PubKey, wallet::LedgerParams};

use crate::{
    models::{ftoken::FTokenInfo, settings::WalletSettingsInfo},
    utils::{
        errors::ServiceError,
        utils::{get_last_wallet, pubkey_from_provider, with_service, with_service_mut},
    },
};

pub struct LedgerParamsInput {
    pub pub_keys: Vec<(u8, String)>,
    pub wallet_index: usize,
    pub wallet_name: String,
    pub ledger_id: String,
    pub account_names: Vec<String>,
    pub biometric_type: String,
    pub identifiers: Vec<String>,
    pub chain_hash: u64,
    pub zilliqa_legacy: bool,
}

pub async fn add_ledger_wallet(
    params: LedgerParamsInput,
    wallet_settings: WalletSettingsInfo,
    ftokens: Vec<FTokenInfo>,
) -> Result<(String, String), String> {
    with_service_mut(|core| {
        let provider = core.get_provider(params.chain_hash)?;
        let bip49 = provider.get_bip49(params.wallet_index);
        let pub_keys = params
            .pub_keys
            .into_iter()
            .map(|(ledger_index, pk)| {
                pubkey_from_provider(&pk, bip49, params.zilliqa_legacy)
                    .map(|pub_key| (ledger_index, pub_key))
            })
            .collect::<Result<Vec<(u8, PubKey)>, ServiceError>>()?;
        let ftokens = ftokens
            .into_iter()
            .map(TryFrom::try_from)
            .collect::<Result<Vec<FToken>, TokenError>>()?;
        let identifiers = params.identifiers;
        let params = BackgroundLedgerParams {
            ftokens,
            pub_keys,
            chain_hash: params.chain_hash,
            account_names: params.account_names,
            wallet_index: params.wallet_index,
            wallet_name: params.wallet_name,
            ledger_id: params.ledger_id.as_bytes().to_vec(),
            biometric_type: params.biometric_type.into(),
            wallet_settings: wallet_settings.try_into()?,
        };

        let session = core
            .add_ledger_wallet(params, WalletSettings::default(), &identifiers)
            .map_err(ServiceError::BackgroundError)?;
        let wallet = get_last_wallet(core)?;

        Ok((hex::encode(session), hex::encode(wallet.wallet_address)))
    })
    .await
    .map_err(Into::into)
}

pub async fn update_ledger_accounts(
    wallet_index: usize,
    accounts: Vec<(u8, String, String)>, // index, pubkey, name
    zilliqa_legacy: bool,
) -> Result<(), String> {
    with_service(|core| {
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let wallet_data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        let provider = core.get_provider(wallet_data.default_chain_hash)?;
        let bip49 = provider.get_bip49(wallet_index);
        let mut accounts = accounts
            .into_iter()
            .map(|(ledger_index, pk, name)| {
                pubkey_from_provider(&pk, bip49, zilliqa_legacy)
                    .map(|pub_key| (ledger_index, pub_key, name))
            })
            .collect::<Result<Vec<(u8, PubKey, String)>, ServiceError>>()?;

        accounts.dedup_by(|a, b| a.0 == b.0 && a.1 == b.1);

        wallet
            .update_ledger_accounts(accounts, &provider.config)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}
