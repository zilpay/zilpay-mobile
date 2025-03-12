// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZilPay Wallet';

  @override
  String get initialPagerestoreZilPay => 'Restore ZilPay 1.0!';

  @override
  String get initialPagegetStarted => 'Get Started';

  @override
  String get restoreRKStorageTitle => 'Migrate ZilPay 1.0 to 2.0';

  @override
  String get restoreRKStorageAccountsPrompt => 'Accounts to migrate to ZilPay 2.0. Enter password.';

  @override
  String get restoreRKStoragePasswordHint => 'Password';

  @override
  String get restoreRKStorageEnterPassword => 'Enter password';

  @override
  String get restoreRKStorageErrorPrefix => 'Error:';

  @override
  String get restoreRKStorageRestoreButton => 'Restore';

  @override
  String get restoreRKStorageSkipButton => 'Skip';

  @override
  String get accountItemBalanceLabel => 'Balance:';

  @override
  String get sendTokenPageTitle => '';

  @override
  String get sendTokenPageSubmitButton => 'Submit';

  @override
  String get aboutPageTitle => 'About';

  @override
  String get aboutPageAppName => 'ZilPay';

  @override
  String get aboutPageAppDescription => 'Your Secure Blockchain Wallet';

  @override
  String get aboutPageAppInfoTitle => 'Application Info';

  @override
  String get aboutPageVersionLabel => 'Version';

  @override
  String get aboutPageBuildDateLabel => 'Build Date';

  @override
  String get aboutPageBuildDateValue => 'March 10, 2025';

  @override
  String get aboutPagePlatformLabel => 'Platform';

  @override
  String get aboutPageDeveloperTitle => 'Developer';

  @override
  String get aboutPageAuthorLabel => 'Author';

  @override
  String get aboutPageAuthorValue => 'Rinat (hicaru)';

  @override
  String get aboutPageWebsiteLabel => 'Website';

  @override
  String get aboutPageWebsiteValue => 'https://zilpay.io';

  @override
  String get aboutPageLegalTitle => 'Legal';

  @override
  String get aboutPagePrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutPageTermsOfService => 'Terms of Service';

  @override
  String get aboutPageLicenses => 'Licenses';

  @override
  String get aboutPageLegalese => '© 2025 ZilPay. All rights reserved.';

  @override
  String get languagePageTitle => 'Language';

  @override
  String get languagePageSystem => 'System';

  @override
  String get languagePageRussian => 'Russian';

  @override
  String get languagePageEnglish => 'English';

  @override
  String get languagePageTurkish => 'Turkish';

  @override
  String get languagePageChinese => 'Chinese';

  @override
  String get languagePageUzbek => 'Uzbek';

  @override
  String get languagePageIndonesian => 'Indonesian';

  @override
  String get languagePageUkrainian => 'Ukrainian';

  @override
  String get languagePageEnglishLocal => 'English';

  @override
  String get languagePageRussianLocal => 'Русский';

  @override
  String get languagePageTurkishLocal => 'Türkçe';

  @override
  String get languagePageChineseLocal => '简体中文';

  @override
  String get languagePageUzbekLocal => 'O\'zbekcha';

  @override
  String get languagePageIndonesianLocal => 'Bahasa Indonesia';

  @override
  String get languagePageUkrainianLocal => 'Українська';

  @override
  String get secretKeyGeneratorPageTitle => 'Secret Key';

  @override
  String get secretKeyGeneratorPagePrivateKey => 'Private Key';

  @override
  String get secretKeyGeneratorPagePublicKey => 'Public Key';

  @override
  String get secretKeyGeneratorPageBackupCheckbox => 'I have backup secret key';

  @override
  String get secretKeyGeneratorPageNextButton => 'Next';

  @override
  String get walletPageTitle => '';

  @override
  String get walletPageWalletNameHint => 'Wallet name';

  @override
  String get walletPagePreferencesTitle => 'Wallet preferences';

  @override
  String get walletPageManageConnections => 'Manage connections';

  @override
  String get walletPageBackup => 'Backup';

  @override
  String get walletPageDeleteWallet => 'Delete Wallet';

  @override
  String get walletPageBiometricReason => 'Enable biometric authentication';

  @override
  String get networkPageTitle => '';

  @override
  String get networkPageShowTestnet => 'Show Testnet';

  @override
  String get networkPageSearchHint => 'Search';

  @override
  String get networkPageAddedNetworks => 'Added Networks';

  @override
  String get networkPageAvailableNetworks => 'Available Networks';

  @override
  String get networkPageLoadError => 'Failed to load network chains: ';

  @override
  String get networkPageAddError => 'Failed to add network: ';

  @override
  String get receivePageTitle => 'Receive';

  @override
  String receivePageWarning(Object chainName, Object tokenSymbol) {
    return 'Only send $chainName($tokenSymbol) assets to this address. Other assets will be lost forever.';
  }

  @override
  String get receivePageAccountNameHint => 'Account name';

  @override
  String get receivePageAmountDialogTitle => 'Enter Amount';

  @override
  String get receivePageAmountDialogHint => '0.0';

  @override
  String get receivePageAmountDialogCancel => 'Cancel';

  @override
  String get receivePageAmountDialogConfirm => 'Confirm';

  @override
  String get securityPageTitle => 'Security';

  @override
  String get securityPageNetworkPrivacy => 'Network Privacy';

  @override
  String get securityPageEnsDomains => 'Show ENS domains in address bar';

  @override
  String get securityPageEnsDescription => 'Keep in mind that using this feature exposes your IP address to IPFS third-party services.';

  @override
  String get securityPageIpfsGateway => 'IPFS gateway';

  @override
  String get securityPageIpfsDescription => 'ZIlPay uses third-party services to show images of your NFTs stored on IPFS, display information related to ENS(ZNS) addresses entered in your browser\'s address bar, and fetch icons for different tokens. Your IP address may be exposed to these services when you\'re using them.';

  @override
  String get securityPageGasStation => 'Gas station';

  @override
  String get securityPageGasDescription => 'Use ZilPay server for optimize your gas usage';

  @override
  String get securityPageNodeRanking => 'Node ranking';

  @override
  String get securityPageNodeDescription => 'Make requests to ZilPay server for fetch best node';

  @override
  String get securityPageEncryptionLevel => 'Encryption Level';

  @override
  String get securityPageProtection => 'Protection';

  @override
  String get securityPageCpuLoad => 'CPU Load';

  @override
  String get securityPageAes256 => 'AES256';

  @override
  String get securityPageKuznechikGost => 'KUZNECHIK-GOST';

  @override
  String get securityPageNtruPrime => 'NTRUPrime';

  @override
  String get securityPageCyber => 'Cyber';

  @override
  String get securityPageUnknown => 'Unknown';

  @override
  String get webViewPageDntLabel => 'DNT';

  @override
  String get webViewPageIncognitoLabel => 'Incognito';

  @override
  String get webViewPageLoadError => 'Failed to load';

  @override
  String get webViewPageTryAgain => 'Try Again';

  @override
  String get addTokenPageTitle => 'Add Token';

  @override
  String get addTokenPageTokenInfo => 'Token Information';

  @override
  String get addTokenPageHint => 'Address, name, symbol';

  @override
  String get addTokenPageAddError => 'Failed to add token:';

  @override
  String get addTokenPageInvalidAddressError => 'Invalid token address or network error';

  @override
  String get secretPhraseGeneratorPageTitle => 'New Wallet';

  @override
  String get secretPhraseGeneratorPageBackupCheckbox => 'I have backup words';

  @override
  String get secretPhraseGeneratorPageNextButton => 'Next';

  @override
  String get homePageTestnetLabel => 'Testnet';

  @override
  String get revealSecretKeyTitle => 'Reveal Secret Key';

  @override
  String get revealSecretKeyPasswordHint => 'Password';

  @override
  String get revealSecretKeyInvalidPassword => 'invalid password, error:';

  @override
  String get revealSecretKeySubmitButton => 'Submit';

  @override
  String get revealSecretKeyDoneButton => 'Done';

  @override
  String get revealSecretKeyScamAlertTitle => 'SCAM ALERT';

  @override
  String get revealSecretKeyScamAlertMessage => 'Never share your secret key with anyone. Never input it on any website.';

  @override
  String get setupNetworkSettingsPageTestnetSwitch => 'Testnet';

  @override
  String get setupNetworkSettingsPageSearchHint => 'Search';

  @override
  String get setupNetworkSettingsPageLoadError => 'Failed to load network chains:';

  @override
  String get setupNetworkSettingsPageNoNetworks => 'No networks available';

  @override
  String setupNetworkSettingsPageNoResults(Object searchQuery) {
    return 'No networks found for \"$searchQuery\"';
  }

  @override
  String get setupNetworkSettingsPageNextButton => 'Next';

  @override
  String get setupNetworkSettingsPageTestnetLabel => 'Testnet';

  @override
  String get setupNetworkSettingsPageMainnetLabel => 'Mainnet';

  @override
  String get setupNetworkSettingsPageChainIdLabel => 'Chain ID:';

  @override
  String get setupNetworkSettingsPageTokenLabel => 'Token:';

  @override
  String get setupNetworkSettingsPageExplorerLabel => 'Explorer:';

  @override
  String get appearanceSettingsPageTitle => 'Appearance Settings';

  @override
  String get appearanceSettingsPageCompactNumbersTitle => 'Compact Numbers';

  @override
  String get appearanceSettingsPageCompactNumbersDescription => 'Enable to display abbreviated numbers (e.g., 20K instead of 20,000).';

  @override
  String get appearanceSettingsPageDeviceSettingsTitle => 'Device settings';

  @override
  String get appearanceSettingsPageDeviceSettingsSubtitle => 'System default';

  @override
  String get appearanceSettingsPageDeviceSettingsDescription => 'Default to your device\'s appearance. Your wallet theme will automatically adjust based on your system settings.';

  @override
  String get appearanceSettingsPageDarkModeTitle => 'Dark Mode';

  @override
  String get appearanceSettingsPageDarkModeSubtitle => 'Always dark';

  @override
  String get appearanceSettingsPageDarkModeDescription => 'Keep the dark theme enabled at all times, regardless of your device settings.';

  @override
  String get appearanceSettingsPageLightModeTitle => 'Light mode';

  @override
  String get appearanceSettingsPageLightModeSubtitle => 'Always light';

  @override
  String get appearanceSettingsPageLightModeDescription => 'Keep the light theme enabled at all times, regardless of your device settings.';

  @override
  String get loginPageBiometricReason => 'Please authenticate';

  @override
  String loginPageWalletTitle(Object index) {
    return 'Wallet $index';
  }

  @override
  String get loginPagePasswordHint => 'Password';

  @override
  String get loginPageUnlockButton => 'Unlock';

  @override
  String get loginPageWelcomeBack => 'Welcome back';

  @override
  String get secretKeyRestorePageTitle => 'Restore Secret Key';

  @override
  String get secretKeyRestorePageHint => 'Private Key';

  @override
  String get secretKeyRestorePageInvalidFormat => 'Invalid private key format';

  @override
  String get secretKeyRestorePageKeyTitle => 'Private Key';

  @override
  String get secretKeyRestorePageBackupLabel => 'I have backed up my secret key';

  @override
  String get secretKeyRestorePageNextButton => 'Next';

  @override
  String get addAccountPageTitle => 'Add New Account';

  @override
  String get addAccountPageSubtitle => 'Create BIP39 Account';

  @override
  String addAccountPageDefaultName(Object index) {
    return 'Account $index';
  }

  @override
  String get addAccountPageNameHint => 'Account name';

  @override
  String get addAccountPageBip39Index => 'BIP39 Index';

  @override
  String get addAccountPageUseBiometrics => 'Use Biometrics';

  @override
  String get addAccountPagePasswordHint => 'Password';

  @override
  String get addAccountPageZilliqaLegacy => 'Zilliqa Legacy';

  @override
  String get addAccountPageBiometricReason => 'Authenticate to create a new account';

  @override
  String addAccountPageBiometricError(Object error) {
    return 'Biometric authentication failed: $error';
  }

  @override
  String addAccountPageIndexExists(Object index) {
    return 'Account with index $index already exists';
  }

  @override
  String get addAccountPageBiometricFailed => 'Biometric authentication failed';

  @override
  String addAccountPageCreateFailed(Object error) {
    return 'Failed to create account: $error';
  }

  @override
  String get addressBookPageTitle => 'Address Book';

  @override
  String get addressBookPageEmptyMessage => 'Your contacts and their wallet address will\nappear here.';

  @override
  String addressBookPageNetwork(Object network) {
    return 'Network $network';
  }

  @override
  String get browserPageConnectedTab => 'Connected';

  @override
  String get browserPageExploreTab => 'Explore';

  @override
  String get browserPageNoExploreApps => 'No apps to explore yet';

  @override
  String browserPageSearchHint(Object engine) {
    return 'Search with $engine or enter address';
  }

  @override
  String get browserPageNoConnectedApps => 'No connected apps';

  @override
  String get historyPageTitle => 'Transaction History';

  @override
  String get historyPageNoTransactions => 'No transactions yet';

  @override
  String get historyPageSearchHint => 'Search transactions...';

  @override
  String get notificationsSettingsPageTitle => 'Notifications';

  @override
  String get notificationsSettingsPagePushTitle => 'Push notifications';

  @override
  String get notificationsSettingsPagePushDescription => 'Get notifications when tx sent and confirm, Notifications from connected apps.';

  @override
  String get notificationsSettingsPageWalletsTitle => 'Wallets';

  @override
  String get notificationsSettingsPageWalletsDescription => 'Notifications from wallets';

  @override
  String get notificationsSettingsPageWalletPrefix => 'Wallet';

  @override
  String get revealSecretPhraseTitle => 'Reveal Secret Phrase';

  @override
  String get revealSecretPhrasePasswordHint => 'Password';

  @override
  String get revealSecretPhraseInvalidPassword => 'invalid password, error:';

  @override
  String get revealSecretPhraseSubmitButton => 'Submit';

  @override
  String get revealSecretPhraseDoneButton => 'Done';

  @override
  String get revealSecretPhraseScamAlertTitle => 'SCAM ALERT';

  @override
  String get revealSecretPhraseScamAlertDescription => 'Never share your secret phrase with anyone. Never input it on any website.';

  @override
  String get cipherSettingsPageTitle => 'Encryption Setup';

  @override
  String get cipherSettingsPageAdvancedButton => 'Advanced';

  @override
  String get cipherSettingsPageStandardTitle => 'Standard Encryption';

  @override
  String get cipherSettingsPageStandardSubtitle => 'AES-256 + KUZNECHIK-GOST';

  @override
  String get cipherSettingsPageStandardDescription => 'Basic encryption with AES-256 and GOST standard KUZNECHIK.';

  @override
  String get cipherSettingsPageHybridTitle => 'Hybrid Encryption';

  @override
  String get cipherSettingsPageHybridSubtitle => 'CYBER + KUZNECHIK-GOST';

  @override
  String get cipherSettingsPageHybridDescription => 'Hybrid encryption combining CYBER and KUZNECHIK-GOST algorithms.';

  @override
  String get cipherSettingsPageQuantumTitle => 'Quantum-Resistant';

  @override
  String get cipherSettingsPageQuantumSubtitle => 'CYBER + KUZNECHIK + NTRUP1277';

  @override
  String get cipherSettingsPageQuantumDescription => 'Advanced quantum-resistant encryption with NTRUP1277.';

  @override
  String get cipherSettingsPageQuantumWarning => 'Quantum-resistant encryption may impact performance';

  @override
  String get cipherSettingsPageConfirmButton => 'Confirm';

  @override
  String get secretPhraseVerifyPageTitle => 'Verify Secret';

  @override
  String get secretPhraseVerifyPageSkipButton => 'Skip';

  @override
  String get secretPhraseVerifyPageSubtitle => 'Verify Bip39 Secret';

  @override
  String get secretPhraseVerifyPageNextButton => 'Next';

  @override
  String get restoreSecretPhrasePageTitle => 'Restore Wallet';

  @override
  String get restoreSecretPhrasePageRestoreButton => 'Restore';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageZilliqaLegacy => 'Zilliqa Legacy';

  @override
  String get settingsPageCurrency => 'Currency';

  @override
  String get settingsPageAppearance => 'Appearance';

  @override
  String get settingsPageNotifications => 'Notifications';

  @override
  String get settingsPageAddressBook => 'Address book';

  @override
  String get settingsPageSecurityPrivacy => 'Security & privacy';

  @override
  String get settingsPageNetworks => 'Networks';

  @override
  String get settingsPageLanguage => 'Language';

  @override
  String get settingsPageBrowser => 'Browser';

  @override
  String get settingsPageTelegram => 'Telegram';

  @override
  String get settingsPageTwitter => 'Twitter';

  @override
  String get settingsPageGitHub => 'GitHub';

  @override
  String get settingsPageAbout => 'About';

  @override
  String get ledgerConnectPageTitle => 'Ledger Connect';

  @override
  String get passwordSetupPageTitle => 'Password Setup';

  @override
  String get passwordSetupPageSubtitle => 'Create Password';

  @override
  String get passwordSetupPageWalletNameHint => 'Wallet Name';

  @override
  String get passwordSetupPagePasswordHint => 'Password';

  @override
  String get passwordSetupPageConfirmPasswordHint => 'Confirm Password';

  @override
  String get passwordSetupPageEmptyWalletNameError => 'Wallet name cannot be empty';

  @override
  String get passwordSetupPageLongWalletNameError => 'Wallet name is too long';

  @override
  String get passwordSetupPageShortPasswordError => 'Password must be at least 8 characters';

  @override
  String get passwordSetupPageMismatchPasswordError => 'Passwords do not match';

  @override
  String get passwordSetupPageLegacyLabel => 'Legacy';

  @override
  String get passwordSetupPageCreateButton => 'Create Password';

  @override
  String get passwordSetupPageAuthReason => 'Please authenticate to enable quick access';

  @override
  String get passwordSetupPageSeedType => 'Seed';

  @override
  String get passwordSetupPageKeyType => 'Key';

  @override
  String get passwordSetupPageUniversalNetwork => 'Universal';

  @override
  String get browserSettingsTitle => 'Browser Settings';

  @override
  String get browserSettingsBrowserOptions => 'Browser Options';

  @override
  String get browserSettingsSearchEngine => 'Search Engine';

  @override
  String get browserSettingsSearchEngineDescription => 'Configure your default search engine';

  @override
  String get browserSettingsSearchEngineTitle => 'Search Engine';

  @override
  String get browserSettingsContentBlocking => 'Content Blocking';

  @override
  String get browserSettingsContentBlockingDescription => 'Configure content blocking settings';

  @override
  String get browserSettingsContentBlockingTitle => 'Content Blocking';

  @override
  String get browserSettingsPrivacySecurity => 'Privacy & Security';

  @override
  String get browserSettingsCookies => 'Cookies';

  @override
  String get browserSettingsCookiesDescription => 'Allow websites to save and read cookies';

  @override
  String get browserSettingsDoNotTrack => 'Do Not Track';

  @override
  String get browserSettingsDoNotTrackDescription => 'Request websites not to track your browsing';

  @override
  String get browserSettingsIncognitoMode => 'Incognito Mode';

  @override
  String get browserSettingsIncognitoModeDescription => 'Browse without saving history or cookies';

  @override
  String get browserSettingsPerformance => 'Performance';

  @override
  String get browserSettingsCache => 'Cache';

  @override
  String get browserSettingsCacheDescription => 'Store website data for faster loading';

  @override
  String get genWalletOptionsTitle => 'Generate Wallet';

  @override
  String get genWalletOptionsBIP39Title => 'BIP39';

  @override
  String get genWalletOptionsBIP39Subtitle => 'Generate Mnemonic phrase';

  @override
  String get genWalletOptionsSLIP0039Title => 'SLIP-0039';

  @override
  String get genWalletOptionsSLIP0039Subtitle => 'Generate Mnemonic phrase with share';

  @override
  String get genWalletOptionsPrivateKeyTitle => 'Private Key';

  @override
  String get genWalletOptionsPrivateKeySubtitle => 'Generate just one private key';

  @override
  String get addWalletOptionsTitle => 'Add Wallet';

  @override
  String get addWalletOptionsNewWalletTitle => 'New Wallet';

  @override
  String get addWalletOptionsNewWalletSubtitle => 'Create new wallet';

  @override
  String get addWalletOptionsExistingWalletTitle => 'Existing Wallet';

  @override
  String get addWalletOptionsExistingWalletSubtitle => 'Import wallet with a 24 secret recovery words';

  @override
  String get addWalletOptionsPairWithLedgerTitle => 'Pair with Ledger';

  @override
  String get addWalletOptionsPairWithLedgerSubtitle => 'Hardware module, Bluetooth';

  @override
  String get addWalletOptionsOtherOptions => 'Other options';

  @override
  String get addWalletOptionsWatchAccountTitle => 'Watch Account';

  @override
  String get addWalletOptionsWatchAccountSubtitle => 'For monitor wallet activity without recovery phrase';

  @override
  String get currencyConversionTitle => 'Primary Currency';

  @override
  String get currencyConversionSearchHint => 'Search currencies...';

  @override
  String get currencyConversionEngineTitle => 'Currency Engine';

  @override
  String get currencyConversionEngineDescription => 'Engine for fetching currency rates';

  @override
  String get currencyConversionEngineSelectorTitle => 'Select Currency Engine';

  @override
  String get currencyConversionEngineNone => 'None';

  @override
  String get currencyConversionEngineNoneSubtitle => 'No engine selected';

  @override
  String get currencyConversionEngineCoingecko => 'Coingecko';

  @override
  String get currencyConversionEngineCoingeckoSubtitle => 'Fetch rates from Coingecko';

  @override
  String get restoreWalletOptionsTitle => 'Restore Wallet';

  @override
  String get restoreWalletOptionsBIP39Title => 'BIP39';

  @override
  String get restoreWalletOptionsBIP39Subtitle => 'Restore with Mnemonic phrase';

  @override
  String get restoreWalletOptionsSLIP0039Title => 'SLIP-0039';

  @override
  String get restoreWalletOptionsSLIP0039Subtitle => 'Restore with Shared Mnemonic phrase';

  @override
  String get restoreWalletOptionsPrivateKeyTitle => 'Private Key';

  @override
  String get restoreWalletOptionsPrivateKeySubtitle => 'Restore with private key';

  @override
  String get restoreWalletOptionsQRCodeTitle => 'QRcode';

  @override
  String get restoreWalletOptionsQRCodeSubtitle => 'Restore wallet by QRcode scanning';

  @override
  String get argonSettingsModalContentLowMemoryTitle => 'Low Memory';

  @override
  String get argonSettingsModalContentLowMemorySubtitle => '64KB RAM, 3 iterations';

  @override
  String get argonSettingsModalContentLowMemoryDescription => 'Minimal memory usage, suitable for low-end devices.';

  @override
  String get argonSettingsModalContentOwaspTitle => 'OWASP Default';

  @override
  String get argonSettingsModalContentOwaspSubtitle => '6.5MB RAM, 2 iterations';

  @override
  String get argonSettingsModalContentOwaspDescription => 'Recommended by OWASP for general use.';

  @override
  String get argonSettingsModalContentSecureTitle => 'Secure';

  @override
  String get argonSettingsModalContentSecureSubtitle => '256MB RAM, 4 iterations';

  @override
  String get argonSettingsModalContentSecureDescription => 'High security with increased memory and iterations.';

  @override
  String get argonSettingsModalContentSecretHint => 'Enter secret (optional)';

  @override
  String get argonSettingsModalContentConfirmButton => 'Confirm';

  @override
  String get confirmTransactionContentPasswordHint => 'Password';

  @override
  String get confirmTransactionContentUnableToConfirm => 'Unable to confirm';

  @override
  String get confirmTransactionContentConfirm => 'Confirm';

  @override
  String get confirmTransactionContentInsufficientBalance => 'Insufficient balance';

  @override
  String get confirmTransactionContentNoActiveAccount => 'No active account';

  @override
  String get confirmTransactionContentFailedLoadTransfer => 'Failed to load transfer details';

  @override
  String get authReason => 'Please authenticate';

  @override
  String get addChainModalContentWarning => 'Beware of network scams and security risks.';

  @override
  String get addChainModalContentApprove => 'Approve';

  @override
  String get addChainModalContentDetails => 'Details';

  @override
  String get addChainModalContentNetworkName => 'Network Name:';

  @override
  String get addChainModalContentCurrencySymbol => 'Currency Symbol:';

  @override
  String get addChainModalContentChainId => 'Chain ID:';

  @override
  String get addChainModalContentBlockExplorer => 'Block Explorer:';

  @override
  String get addAddressModalTitle => 'Add Contact';

  @override
  String get addAddressModalDescription => 'Enter the contact name and wallet address to add to your address book.';

  @override
  String get addAddressModalNameHint => 'Name';

  @override
  String get addAddressModalAddressHint => 'Wallet Address';

  @override
  String get addAddressModalNameEmptyError => 'Name cannot be empty';

  @override
  String get addAddressModalAddressEmptyError => 'Address cannot be empty';

  @override
  String get addAddressModalButton => 'Add Contact';

  @override
  String get tokenSelectModalContentSearchHint => 'Search';

  @override
  String get signMessageModalContentAuthReason => 'Please authenticate to sign the message';

  @override
  String get signMessageModalContentFailedToSign => 'Failed to sign:';

  @override
  String get signMessageModalContentTitle => 'Sign Message';

  @override
  String get signMessageModalContentDescription => 'Review and sign the following message with your wallet.';

  @override
  String get signMessageModalContentDomain => 'Domain:';

  @override
  String get signMessageModalContentChainId => 'Chain ID:';

  @override
  String get signMessageModalContentContract => 'Contract:';

  @override
  String get signMessageModalContentType => 'Type:';

  @override
  String get signMessageModalContentNoData => 'No data';

  @override
  String get signMessageModalContentPasswordHint => 'Password';

  @override
  String get signMessageModalContentProcessing => 'Processing...';

  @override
  String get signMessageModalContentSign => 'Sign Message';

  @override
  String get deleteWalletModalTitle => 'Delete Wallet';

  @override
  String get deleteWalletModalWarning => 'Warning: This action cannot be undone. Your wallet can only be recovered using your secret phrase. If you don\'t have access to it, you will permanently lose all funds associated with this account.';

  @override
  String get deleteWalletModalSecretPhraseWarning => 'Please make sure you have access to your secret phrase before proceeding.';

  @override
  String get deleteWalletModalPasswordHint => 'Enter Password';

  @override
  String get deleteWalletModalSubmit => 'Submit';

  @override
  String get manageTokensModalContentSearchHint => 'Search';

  @override
  String get addressSelectModalContentTitle => 'Select Address';

  @override
  String get addressSelectModalContentSearchHint => 'Search / Address / ENS';

  @override
  String get addressSelectModalContentUnknown => 'Unknown';

  @override
  String get addressSelectModalContentMyAccounts => 'My Accounts';

  @override
  String get addressSelectModalContentAddressBook => 'Address Book';

  @override
  String get addressSelectModalContentHistory => 'History';

  @override
  String get changePasswordModalTitle => 'Change Password';

  @override
  String get changePasswordModalDescription => 'Enter your current password and choose a new password to update your wallet security.';

  @override
  String get changePasswordModalCurrentPasswordHint => 'Current Password';

  @override
  String get changePasswordModalNewPasswordHint => 'New Password';

  @override
  String get changePasswordModalConfirmPasswordHint => 'Confirm New Password';

  @override
  String get changePasswordModalCurrentPasswordEmptyError => 'Current password cannot be empty';

  @override
  String get changePasswordModalPasswordLengthError => 'Password must be at least 6 characters';

  @override
  String get changePasswordModalPasswordsMismatchError => 'Passwords do not match';

  @override
  String get changePasswordModalButton => 'Change Password';

  @override
  String get confirmPasswordModalTitle => 'Confirm Password';

  @override
  String get confirmPasswordModalDescription => 'Enter your password to continue.';

  @override
  String get confirmPasswordModalHint => 'Password';

  @override
  String get confirmPasswordModalEmptyError => 'Password cannot be empty';

  @override
  String get confirmPasswordModalIncorrectError => 'Incorrect password';

  @override
  String get confirmPasswordModalGenericError => 'Error:';

  @override
  String get confirmPasswordModalButton => 'Confirm';

  @override
  String get qrScannerModalContentTitle => 'Scan';

  @override
  String get qrScannerModalContentCameraInitError => 'Camera initialization error:';

  @override
  String get qrScannerModalContentTorchError => 'Failed to toggle torch:';

  @override
  String get qrScannerModalContentOpenSettings => 'Open Settings';

  @override
  String get chainInfoModalContentNetworkInfoTitle => 'Network Information';

  @override
  String get chainInfoModalContentChainLabel => 'Chain';

  @override
  String get chainInfoModalContentShortNameLabel => 'Short Name';

  @override
  String get chainInfoModalContentChainIdLabel => 'Chain ID';

  @override
  String get chainInfoModalContentSlip44Label => 'Slip44';

  @override
  String get chainInfoModalContentChainIdsLabel => 'Chain IDs';

  @override
  String get chainInfoModalContentTestnetLabel => 'Testnet';

  @override
  String get chainInfoModalContentYes => 'Yes';

  @override
  String get chainInfoModalContentNo => 'No';

  @override
  String get chainInfoModalContentDiffBlockTimeLabel => 'Diff Block Time';

  @override
  String get chainInfoModalContentFallbackEnabledLabel => 'Fallback Enabled';

  @override
  String get chainInfoModalContentDecimalsLabel => 'Decimals';

  @override
  String get chainInfoModalContentRpcNodesTitle => 'RPC Nodes';

  @override
  String get chainInfoModalContentExplorersTitle => 'Explorers';

  @override
  String get switchChainNetworkContentTitle => 'Select Network';

  @override
  String get switchChainNetworkContentButton => 'Switch Network';

  @override
  String get switchChainNetworkContentTestnetLabel => 'Testnet';

  @override
  String get switchChainNetworkContentIdLabel => 'ID:';

  @override
  String get watchAssetModalContentTitle => 'Add suggested token';

  @override
  String get watchAssetModalContentDescription => 'Review and add the following token suggested by the app.';

  @override
  String get watchAssetModalContentTokenLabel => 'Token';

  @override
  String get watchAssetModalContentBalanceLabel => 'Balance';

  @override
  String get watchAssetModalContentLoadingButton => 'Balance...';

  @override
  String get watchAssetModalContentAddButton => 'Add';

  @override
  String get connectedDappsModalSearchHint => 'Search DApps';

  @override
  String get connectedDappsModalNoDapps => 'No connected DApps';

  @override
  String dappListItemConnected(Object time) {
    return 'Connected $time';
  }

  @override
  String get dappListItemJustNow => 'just now';

  @override
  String get ledgerConnectDialogWalletNameHint => 'Wallet Name';

  @override
  String get ledgerConnectDialogEmptyWalletName => 'Wallet name cannot be empty';

  @override
  String get ledgerConnectDialogWalletNameTooLong => 'Wallet name is too long';

  @override
  String get ledgerConnectDialogConnectButton => 'Connect';

  @override
  String get secretRecoveryModalRevealPhraseTitle => 'Reveal Secret Recovery Phrase';

  @override
  String get secretRecoveryModalRevealPhraseDescription => 'If you ever change browsers or move computers, you will need this Secret Recovery Phrase to access your accounts. Save them somewhere safe and secret.';

  @override
  String get secretRecoveryModalRevealPhraseButton => 'Reveal';

  @override
  String get secretRecoveryModalShowKeysTitle => 'Show Private Keys';

  @override
  String get secretRecoveryModalShowKeysDescription => 'Warning: Never disclose this key. Anyone with your private keys can steal any assets held in your account.';

  @override
  String get secretRecoveryModalShowKeysButton => 'Export';

  @override
  String get backupConfirmationContentTitle => 'Backup Confirmation';

  @override
  String get backupConfirmationContentWrittenDown => 'I have written down all';

  @override
  String get backupConfirmationContentSafelyStored => 'I have safely stored the backup';

  @override
  String get backupConfirmationContentWontLose => 'I am sure I won\'t lose the backup';

  @override
  String get backupConfirmationContentNotShare => 'I understand not to share these words with anyone';
}
