use super::{
    notification::BackgroundNotificationState, provider::NetworkConfigInfo,
    settings::BrowserSettingsInfo, wallet::WalletInfo,
};
use std::collections::HashMap;

pub struct BackgroundState {
    pub wallets: Vec<WalletInfo>,
    pub notifications_wallet_states: HashMap<usize, BackgroundNotificationState>,
    pub notifications_global_enabled: bool,
    pub locale: Option<String>,
    pub appearances: u8,
    pub abbreviated_number: bool,
    pub browser_settings: BrowserSettingsInfo,
    pub providers: Vec<NetworkConfigInfo>,
}
