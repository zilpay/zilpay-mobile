pub mod btc_wallet;
pub mod exchange;

#[cfg(test)]
pub(crate) static TEST_SERVICE_LOCK: zilpay::tokio::sync::Mutex<()> =
    zilpay::tokio::sync::Mutex::const_new(());
