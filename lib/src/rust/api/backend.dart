// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../lib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `from_path`, `stop`
// These types are ignored because they are not used by any `pub` functions: `BACKGROUND_SERVICE`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `clone`, `deref`, `fmt`, `fmt`, `fmt`, `fmt`, `fmt`, `from`, `from`, `from`, `from`, `initialize`

Future<List<WalletInfo>> getWallets() =>
    RustLib.instance.api.crateApiBackendGetWallets();

Future<BackgroundState> getData() =>
    RustLib.instance.api.crateApiBackendGetData();

Future<bool> tryUnlockWithPassword(
        {required String password,
        required BigInt walletIndex,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendTryUnlockWithPassword(
        password: password, walletIndex: walletIndex, identifiers: identifiers);

Future<bool> tryUnlockWithSession(
        {required String sessionCipher,
        required BigInt walletIndex,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendTryUnlockWithSession(
        sessionCipher: sessionCipher,
        walletIndex: walletIndex,
        identifiers: identifiers);

Future<BackgroundState> startService({required String path}) =>
    RustLib.instance.api.crateApiBackendStartService(path: path);

Future<void> stopService() => RustLib.instance.api.crateApiBackendStopService();

Stream<String> startWorker() =>
    RustLib.instance.api.crateApiBackendStartWorker();

Future<bool> isServiceRunning() =>
    RustLib.instance.api.crateApiBackendIsServiceRunning();

Future<(String, String)> addBip39Wallet(
        {required String password,
        required String mnemonicStr,
        required List<(BigInt, String)> accouns,
        required String passphrase,
        required String walletName,
        required String biometricType,
        required Uint64List networks,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendAddBip39Wallet(
        password: password,
        mnemonicStr: mnemonicStr,
        accouns: accouns,
        passphrase: passphrase,
        walletName: walletName,
        biometricType: biometricType,
        networks: networks,
        identifiers: identifiers);

Future<(String, String)> addSkWallet(
        {required String sk,
        required String password,
        required String accountName,
        required String walletName,
        required String biometricType,
        required List<String> identifiers,
        required Uint64List networks}) =>
    RustLib.instance.api.crateApiBackendAddSkWallet(
        sk: sk,
        password: password,
        accountName: accountName,
        walletName: walletName,
        biometricType: biometricType,
        identifiers: identifiers,
        networks: networks);

Future<void> syncBalances({required BigInt walletIndex}) =>
    RustLib.instance.api.crateApiBackendSyncBalances(walletIndex: walletIndex);

Future<FToken> fetchTokenMeta(
        {required String addr, required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiBackendFetchTokenMeta(addr: addr, walletIndex: walletIndex);

Future<void> addNextBip39Account(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        required String name,
        required String passphrase,
        required List<String> identifiers,
        String? password,
        String? sessionCipher}) =>
    RustLib.instance.api.crateApiBackendAddNextBip39Account(
        walletIndex: walletIndex,
        accountIndex: accountIndex,
        name: name,
        passphrase: passphrase,
        identifiers: identifiers,
        password: password,
        sessionCipher: sessionCipher);

Future<void> addLedgerAccount(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        required String name,
        required String pubKey,
        required List<String> identifiers,
        String? sessionCipher}) =>
    RustLib.instance.api.crateApiBackendAddLedgerAccount(
        walletIndex: walletIndex,
        accountIndex: accountIndex,
        name: name,
        pubKey: pubKey,
        identifiers: identifiers,
        sessionCipher: sessionCipher);

Future<(String, String)> addLedgerZilliqaWallet(
        {required String pubKey,
        required BigInt walletIndex,
        required String walletName,
        required String ledgerId,
        required String accountName,
        required String biometricType,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendAddLedgerZilliqaWallet(
        pubKey: pubKey,
        walletIndex: walletIndex,
        walletName: walletName,
        ledgerId: ledgerId,
        accountName: accountName,
        biometricType: biometricType,
        identifiers: identifiers);

Future<void> selectAccount(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiBackendSelectAccount(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<void> setTheme({required int appearancesCode}) => RustLib.instance.api
    .crateApiBackendSetTheme(appearancesCode: appearancesCode);

Future<void> setWalletNotifications(
        {required BigInt walletIndex,
        required bool transactions,
        required bool price,
        required bool security,
        required bool balance}) =>
    RustLib.instance.api.crateApiBackendSetWalletNotifications(
        walletIndex: walletIndex,
        transactions: transactions,
        price: price,
        security: security,
        balance: balance);

Future<void> setGlobalNotifications({required bool globalEnabled}) =>
    RustLib.instance.api
        .crateApiBackendSetGlobalNotifications(globalEnabled: globalEnabled);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < Background >>>
abstract class ArcBackground implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FToken>>
abstract class FToken implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SerivceBackground>>
abstract class SerivceBackground implements RustOpaqueInterface {
  ArcBackground get core;

  RustStreamSink<String>? get messageSink;

  bool get running;

  set core(ArcBackground core);

  set messageSink(RustStreamSink<String>? messageSink);

  set running(bool running);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletInfo>>
abstract class WalletInfo implements RustOpaqueInterface {
  List<AccountInfo> get accounts;

  String get authType;

  BigInt get selectedAccount;

  WalletSettings get settings;

  List<FTokenInfo> get tokens;

  String get walletAddress;

  String get walletName;

  String get walletType;

  set accounts(List<AccountInfo> accounts);

  set authType(String authType);

  set selectedAccount(BigInt selectedAccount);

  set settings(WalletSettings settings);

  set tokens(List<FTokenInfo> tokens);

  set walletAddress(String walletAddress);

  set walletName(String walletName);

  set walletType(String walletType);
}

class AccountInfo {
  final String addr;
  final String name;

  const AccountInfo({
    required this.addr,
    required this.name,
  });

  @override
  int get hashCode => addr.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountInfo &&
          runtimeType == other.runtimeType &&
          addr == other.addr &&
          name == other.name;
}

class BackgroundNotificationState {
  final bool transactions;
  final bool price;
  final bool security;
  final bool balance;

  const BackgroundNotificationState({
    required this.transactions,
    required this.price,
    required this.security,
    required this.balance,
  });

  @override
  int get hashCode =>
      transactions.hashCode ^
      price.hashCode ^
      security.hashCode ^
      balance.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundNotificationState &&
          runtimeType == other.runtimeType &&
          transactions == other.transactions &&
          price == other.price &&
          security == other.security &&
          balance == other.balance;
}

class BackgroundState {
  final List<WalletInfo> wallets;
  final Map<BigInt, BackgroundNotificationState> notificationsWalletStates;
  final bool notificationsGlobalEnabled;
  final String locale;
  final int appearances;

  const BackgroundState({
    required this.wallets,
    required this.notificationsWalletStates,
    required this.notificationsGlobalEnabled,
    required this.locale,
    required this.appearances,
  });

  @override
  int get hashCode =>
      wallets.hashCode ^
      notificationsWalletStates.hashCode ^
      notificationsGlobalEnabled.hashCode ^
      locale.hashCode ^
      appearances.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundState &&
          runtimeType == other.runtimeType &&
          wallets == other.wallets &&
          notificationsWalletStates == other.notificationsWalletStates &&
          notificationsGlobalEnabled == other.notificationsGlobalEnabled &&
          locale == other.locale &&
          appearances == other.appearances;
}

class FTokenInfo {
  final String name;
  final String symbol;
  final int decimals;
  final String addr;
  final Map<String, String> balances;
  final bool default_;

  const FTokenInfo({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.addr,
    required this.balances,
    required this.default_,
  });

  @override
  int get hashCode =>
      name.hashCode ^
      symbol.hashCode ^
      decimals.hashCode ^
      addr.hashCode ^
      balances.hashCode ^
      default_.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FTokenInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          symbol == other.symbol &&
          decimals == other.decimals &&
          addr == other.addr &&
          balances == other.balances &&
          default_ == other.default_;
}
