// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'account.dart';
import 'background.dart';
import 'ftoken.dart';
import 'notification.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'wallet.dart';

Future<BackgroundState> startService({required String path}) =>
    RustLib.instance.api.crateApiBackendStartService(path: path);

Future<void> stopService() => RustLib.instance.api.crateApiBackendStopService();

Future<bool> isServiceRunning() =>
    RustLib.instance.api.crateApiBackendIsServiceRunning();

Stream<String> startWorker() =>
    RustLib.instance.api.crateApiBackendStartWorker();

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

Future<(String, String)> addBip39Wallet(
        {required String password,
        required String mnemonicStr,
        required List<(BigInt, String)> accounts,
        required String passphrase,
        required String walletName,
        required String biometricType,
        required Uint64List networks,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendAddBip39Wallet(
        password: password,
        mnemonicStr: mnemonicStr,
        accounts: accounts,
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

Future<(String, String)> addLedgerWallet(
        {required String pubKey,
        required BigInt walletIndex,
        required String walletName,
        required String ledgerId,
        required String accountName,
        required String biometricType,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiBackendAddLedgerWallet(
        pubKey: pubKey,
        walletIndex: walletIndex,
        walletName: walletName,
        ledgerId: ledgerId,
        accountName: accountName,
        biometricType: biometricType,
        identifiers: identifiers);

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

Future<void> selectAccount(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiBackendSelectAccount(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<void> syncBalances({required BigInt walletIndex}) =>
    RustLib.instance.api.crateApiBackendSyncBalances(walletIndex: walletIndex);

Future<FToken> fetchTokenMeta(
        {required String addr, required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiBackendFetchTokenMeta(addr: addr, walletIndex: walletIndex);

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

Future<void> setRateFetcher({required BigInt walletIndex, String? currency}) =>
    RustLib.instance.api.crateApiBackendSetRateFetcher(
        walletIndex: walletIndex, currency: currency);

Future<void> setWalletEns(
        {required BigInt walletIndex, required bool ensEnabled}) =>
    RustLib.instance.api.crateApiBackendSetWalletEns(
        walletIndex: walletIndex, ensEnabled: ensEnabled);

Future<void> setWalletIpfsNode({required BigInt walletIndex, String? node}) =>
    RustLib.instance.api
        .crateApiBackendSetWalletIpfsNode(walletIndex: walletIndex, node: node);

Future<void> setWalletGasControl(
        {required BigInt walletIndex, required bool enabled}) =>
    RustLib.instance.api.crateApiBackendSetWalletGasControl(
        walletIndex: walletIndex, enabled: enabled);

Future<void> setWalletNodeRanking(
        {required BigInt walletIndex, required bool enabled}) =>
    RustLib.instance.api.crateApiBackendSetWalletNodeRanking(
        walletIndex: walletIndex, enabled: enabled);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FToken>>
abstract class FToken implements RustOpaqueInterface {}
