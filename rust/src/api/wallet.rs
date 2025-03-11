use zilpay::background::bg_provider::ProvidersManagement;
use zilpay::background::Background;
use zilpay::errors::background::BackgroundError;
use zilpay::errors::token::TokenError;
use zilpay::errors::wallet::WalletErrors;
use zilpay::proto::address::Address;
use zilpay::token::ft::FToken;
use zilpay::wallet::wallet_crypto::WalletCrypto;
use zilpay::wallet::wallet_storage::StorageOperations;
pub use zilpay::{
    background::bg_wallet::WalletManagement, wallet::wallet_account::AccountManagement,
};
pub use zilpay::{
    background::{BackgroundBip39Params, BackgroundSKParams},
    crypto::bip49::DerivationPath,
    proto::{pubkey::PubKey, secret_key::SecretKey},
};

use crate::models::ftoken::FTokenInfo;
use crate::models::keypair::KeyPairInfo;
use crate::models::settings::WalletSettingsInfo;
use crate::utils::utils::{secretkey_from_provider, with_wallet};
use crate::{
    models::wallet::WalletInfo,
    utils::{
        errors::ServiceError,
        utils::{decode_session, with_service, with_service_mut},
    },
};

pub async fn get_wallets() -> Result<Vec<WalletInfo>, String> {
    with_service(|core| {
        let wallets = core
            .wallets
            .iter()
            .map(|w| w.try_into())
            .collect::<Result<Vec<WalletInfo>, WalletErrors>>()
            .map_err(BackgroundError::WalletError)?;

        Ok(wallets)
    })
    .await
    .map_err(Into::into)
}

pub struct Bip39AddWalletParams {
    pub password: String,
    pub mnemonic_str: String,
    pub mnemonic_check: bool,
    pub accounts: Vec<(usize, String)>,
    pub passphrase: String,
    pub wallet_name: String,
    pub biometric_type: String,
    pub chain_hash: u64,
    pub identifiers: Vec<String>,
}

pub async fn add_bip39_wallet(
    params: Bip39AddWalletParams,
    wallet_settings: WalletSettingsInfo,
    ftokens: Vec<FTokenInfo>,
) -> Result<(String, String), String> {
    with_service_mut(|core| {
        let core_ref: &Background = &*core;
        let provider = core_ref.get_provider(params.chain_hash)?;
        let accounts_bip49 = params
            .accounts
            .into_iter()
            .map(|(i, name)| (provider.get_bip49(i), name))
            .collect::<Vec<(DerivationPath, String)>>();
        let ftokens = ftokens
            .into_iter()
            .map(TryFrom::try_from)
            .collect::<Result<Vec<FToken>, TokenError>>()?;
        let session = core
            .add_bip39_wallet(BackgroundBip39Params {
                ftokens,
                mnemonic_check: params.mnemonic_check,
                wallet_settings: wallet_settings.try_into()?,
                chain_hash: params.chain_hash,
                password: &params.password,
                mnemonic_str: &params.mnemonic_str,
                accounts: &accounts_bip49,
                passphrase: &params.passphrase,
                wallet_name: params.wallet_name,
                biometric_type: params.biometric_type.into(),
                device_indicators: &params.identifiers,
            })
            .map_err(ServiceError::BackgroundError)?;
        let wallet = core.wallets.last().ok_or(ServiceError::FailToSaveWallet)?;

        Ok((hex::encode(session), hex::encode(wallet.wallet_address)))
    })
    .await
    .map_err(Into::into)
}

pub struct AddSKWalletParams {
    pub sk: String,
    pub password: String,
    pub wallet_name: String,
    pub biometric_type: String,
    pub identifiers: Vec<String>,
    pub chain_hash: u64,
}

pub async fn add_sk_wallet(
    params: AddSKWalletParams,
    wallet_settings: WalletSettingsInfo,
    ftokens: Vec<FTokenInfo>,
) -> Result<(String, String), String> {
    with_service_mut(|core| {
        let ftokens = ftokens
            .into_iter()
            .map(TryFrom::try_from)
            .collect::<Result<Vec<FToken>, TokenError>>()?;
        let provider = core.get_provider(params.chain_hash)?;
        let bip49 = provider.get_bip49(0);
        let secret_key = secretkey_from_provider(&params.sk, bip49)?;
        let session = core.add_sk_wallet(BackgroundSKParams {
            ftokens,
            chain_hash: params.chain_hash,
            secret_key,
            wallet_name: params.wallet_name,
            biometric_type: params.biometric_type.into(),
            password: &params.password,
            device_indicators: &params.identifiers,
            wallet_settings: wallet_settings.try_into()?,
        })?;
        let wallet = core.wallets.last().ok_or(ServiceError::FailToSaveWallet)?;

        Ok((hex::encode(session), hex::encode(wallet.wallet_address)))
    })
    .await
    .map_err(Into::into)
}

pub struct AddNextBip39AccountParams {
    pub wallet_index: usize,
    pub account_index: usize,
    pub name: String,
    pub passphrase: String,
    pub identifiers: Vec<String>,
    pub password: Option<String>,
    pub session_cipher: Option<String>,
    pub chain_hash: u64,
}

pub async fn add_next_bip39_account(params: AddNextBip39AccountParams) -> Result<(), String> {
    with_service_mut(|core| {
        let seed = if let Some(pass) = params.password {
            core.unlock_wallet_with_password(&pass, &params.identifiers, params.wallet_index)
        } else {
            let session = decode_session(params.session_cipher)?;
            core.unlock_wallet_with_session(session, &params.identifiers, params.wallet_index)
        }?;

        let wallet = core.get_wallet_by_index(params.wallet_index)?;
        let provider = core.get_provider(params.chain_hash)?;
        let bip49 = provider.get_bip49(params.account_index);

        wallet
            .add_next_bip39_account(
                params.name,
                &bip49,
                &params.passphrase,
                &seed,
                &provider.config,
            )
            .map_err(|e| ServiceError::WalletError(params.wallet_index, e))
    })
    .await
    .map_err(Into::into)
}

pub async fn select_account(wallet_index: usize, account_index: usize) -> Result<(), String> {
    with_wallet(wallet_index, |wallet| {
        wallet
            .select_account(account_index)
            .map_err(|e| ServiceError::AccountError(account_index, wallet_index, e))
    })
    .await
    .map_err(Into::into)
}

pub async fn change_account_name(
    wallet_index: usize,
    account_index: usize,
    new_name: String,
) -> Result<(), String> {
    with_wallet(wallet_index, |wallet| {
        let mut data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        let acc = data
            .accounts
            .get_mut(account_index)
            .ok_or(ServiceError::AccountError(
                account_index,
                wallet_index,
                WalletErrors::InvalidAccountIndex(account_index),
            ))?;

        acc.name = new_name;

        wallet
            .save_wallet_data(data)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn change_wallet_name(wallet_index: usize, new_name: String) -> Result<(), String> {
    with_wallet(wallet_index, |wallet| {
        let mut data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        data.wallet_name = new_name;

        wallet
            .save_wallet_data(data)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn delete_wallet(
    wallet_index: usize,
    identifiers: Vec<String>,
    password: Option<String>,
    session_cipher: Option<String>,
) -> Result<(), String> {
    with_service_mut(|core| {
        if let Some(pass) = password {
            core.unlock_wallet_with_password(&pass, &identifiers, wallet_index)
        } else {
            let session = decode_session(session_cipher)?;
            core.unlock_wallet_with_session(session, &identifiers, wallet_index)
        }?;

        core.delete_wallet(wallet_index)?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn delete_account(wallet_index: usize, account_index: usize) -> Result<(), String> {
    with_wallet(wallet_index, |wallet| {
        wallet
            .delete_account(account_index)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn set_biometric(
    wallet_index: usize,
    identifiers: Vec<String>,
    password: String,
    session_cipher: Option<String>,
    new_biometric_type: String,
) -> Result<Option<Vec<u8>>, String> {
    with_service(|core| {
        let mb_session = if session_cipher.is_some() {
            Some(decode_session(session_cipher)?)
        } else {
            None
        };
        core.set_biometric(
            &password,
            mb_session,
            &identifiers,
            wallet_index,
            new_biometric_type.into(),
        )?;

        Ok(Some(Vec::new()))
    })
    .await
    .map_err(Into::into)
}

pub async fn reveal_keypair(
    wallet_index: usize,
    account_index: usize,
    identifiers: Vec<String>,
    password: String,
    passphrase: Option<String>,
) -> Result<KeyPairInfo, String> {
    with_service(|core| {
        let seed = core.unlock_wallet_with_password(&password, &identifiers, wallet_index)?;
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let keypair = wallet
            .reveal_keypair(account_index, &seed, passphrase.as_deref())
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(keypair.into())
    })
    .await
    .map_err(Into::into)
}

pub async fn reveal_bip39_phrase(
    wallet_index: usize,
    identifiers: Vec<String>,
    password: String,
    _passphrase: Option<String>,
) -> Result<String, String> {
    with_service(|core| {
        let seed = core.unlock_wallet_with_password(&password, &identifiers, wallet_index)?;
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let m = wallet
            .reveal_mnemonic(&seed)
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;

        Ok(m.to_string())
    })
    .await
    .map_err(Into::into)
}

pub async fn zilliqa_swap_chain(wallet_index: usize, account_index: usize) -> Result<(), String> {
    with_service(|core| {
        core.swap_zilliqa_chain(wallet_index, account_index)?;

        Ok(())
    })
    .await
    .map_err(Into::into)
}

pub async fn zilliqa_get_bech32_base16_address(
    wallet_index: usize,
    account_index: usize,
) -> Result<(String, String), String> {
    with_service(|core| {
        let wallet = core.get_wallet_by_index(wallet_index)?;
        let data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        let account = data
            .accounts
            .get(account_index)
            .ok_or(ServiceError::AccountError(
                account_index,
                wallet_index,
                WalletErrors::NoAccounts,
            ))?;

        match account.pub_key {
            PubKey::Secp256k1Sha256(_) => Ok((
                account.addr.get_zil_bech32().unwrap_or_default(),
                account.addr.get_zil_base16().unwrap_or_default(),
            )),
            PubKey::Secp256k1Keccak256(pk) => {
                let addr_result = PubKey::Secp256k1Sha256(pk)
                    .get_addr()
                    .map(|addr| {
                        (
                            addr.get_zil_bech32().unwrap_or_default(),
                            addr.get_zil_base16().unwrap_or_default(),
                        )
                    })
                    .map_err(|_| ServiceError::DecodePublicKey)?;

                Ok(addr_result)
            }
            _ => Err(ServiceError::DecodePublicKey),
        }
    })
    .await
    .map_err(Into::into)
}

pub async fn get_zil_eth_checksum_addresses(wallet_index: usize) -> Result<Vec<String>, String> {
    with_wallet(wallet_index, |wallet| {
        let data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        let addresses = data
            .accounts
            .into_iter()
            .filter_map(|a| match a.pub_key {
                PubKey::Secp256k1Sha256(pk) => PubKey::Secp256k1Keccak256(pk)
                    .get_addr()
                    .ok()
                    .and_then(|a| a.to_eth_checksummed().ok()),
                PubKey::Secp256k1Keccak256(_) => a.addr.to_eth_checksummed().ok(),
                _ => None,
            })
            .collect::<Vec<String>>();

        Ok(addresses)
    })
    .await
    .map_err(Into::into)
}

pub async fn get_zil_bech32_addresses(wallet_index: usize) -> Result<Vec<String>, String> {
    with_wallet(wallet_index, |wallet| {
        let data = wallet
            .get_wallet_data()
            .map_err(|e| ServiceError::WalletError(wallet_index, e))?;
        let addresses = data
            .accounts
            .into_iter()
            .filter_map(|a| match a.pub_key {
                PubKey::Secp256k1Sha256(_) => a.addr.get_zil_bech32().ok(),
                PubKey::Secp256k1Keccak256(pk) => PubKey::Secp256k1Sha256(pk)
                    .get_addr()
                    .ok()
                    .and_then(|addr| addr.get_zil_bech32().ok()),
                _ => None,
            })
            .collect::<Vec<String>>();

        Ok(addresses)
    })
    .await
    .map_err(Into::into)
}

pub fn zilliqa_legacy_base16_to_bech32(base16: String) -> Result<String, String> {
    let addr = Address::from_zil_base16(&base16).map_err(|e| e.to_string())?;

    Ok(addr.get_zil_bech32().unwrap_or_default())
}
