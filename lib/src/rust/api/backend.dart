// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../lib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `from_path`, `stop`
// These types are ignored because they are not used by any `pub` functions: `BACKGROUND_SERVICE`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `deref`, `fmt`, `fmt`, `initialize`

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
        required Uint64List indexes,
        required String passphrase,
        required String walletName,
        required String biometricType,
        required Uint64List netCodes,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendAddBip39Wallet(
        password: password,
        mnemonicStr: mnemonicStr,
        indexes: indexes,
        passphrase: passphrase,
        walletName: walletName,
        biometricType: biometricType,
        netCodes: netCodes,
        identifiers: identifiers);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < Background >>>
abstract class ArcBackground implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BackgroundState>>
abstract class BackgroundState implements RustOpaqueInterface {
  CommonSettings get settings;

  List<WalletInfo> get wallets;

  set settings(CommonSettings settings);

  set wallets(List<WalletInfo> wallets);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Serivce>>
abstract class Serivce implements RustOpaqueInterface {
  ArcBackground get core;

  RustStreamSink<String>? get messageSink;

  bool get running;

  set core(ArcBackground core);

  set messageSink(RustStreamSink<String>? messageSink);

  set running(bool running);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletInfo>>
abstract class WalletInfo implements RustOpaqueInterface {
  List<Account> get accounts;

  String get authType;

  BigInt get selectedAccount;

  WalletSettings get settings;

  String get walletAddress;

  String get walletName;

  int get walletType;

  set accounts(List<Account> accounts);

  set authType(String authType);

  set selectedAccount(BigInt selectedAccount);

  set settings(WalletSettings settings);

  set walletAddress(String walletAddress);

  set walletName(String walletName);

  set walletType(int walletType);
}
