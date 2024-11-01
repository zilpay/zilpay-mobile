// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../lib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `from_path`, `stop`
// These types are ignored because they are not used by any `pub` functions: `BACKGROUND_SERVICE`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `deref`, `fmt`, `initialize`

Future<List<WalletInfo>> getWallets() =>
    RustLib.instance.api.crateApiBackendGetWallets();

Future<List<WalletInfo>> startService({required String path}) =>
    RustLib.instance.api.crateApiBackendStartService(path: path);

Future<void> stopService() => RustLib.instance.api.crateApiBackendStopService();

Stream<String> startWorker() =>
    RustLib.instance.api.crateApiBackendStartWorker();

Future<bool> isServiceRunning() =>
    RustLib.instance.api.crateApiBackendIsServiceRunning();

Future<String> addBip39Wallet(
        {required String password,
        required String mnemonicStr,
        required Uint64List indexes,
        required Uint64List netCodes}) =>
    RustLib.instance.api.crateApiBackendAddBip39Wallet(
        password: password,
        mnemonicStr: mnemonicStr,
        indexes: indexes,
        netCodes: netCodes);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < Background >>>
abstract class ArcBackground implements RustOpaqueInterface {}

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

  bool get enabled;

  BigInt get selectedAccount;

  WalletSettings get settings;

  String get walletAddress;

  WalletTypes get walletType;

  set accounts(List<Account> accounts);

  set enabled(bool enabled);

  set selectedAccount(BigInt selectedAccount);

  set settings(WalletSettings settings);

  set walletAddress(String walletAddress);

  set walletType(WalletTypes walletType);
}
