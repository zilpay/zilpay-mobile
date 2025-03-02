// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> setTheme({required int appearancesCode}) => RustLib.instance.api
    .crateApiSettingsSetTheme(appearancesCode: appearancesCode);

Future<void> setWalletNotifications(
        {required BigInt walletIndex,
        required bool transactions,
        required bool price,
        required bool security,
        required bool balance}) =>
    RustLib.instance.api.crateApiSettingsSetWalletNotifications(
        walletIndex: walletIndex,
        transactions: transactions,
        price: price,
        security: security,
        balance: balance);

Future<void> setGlobalNotifications({required bool globalEnabled}) =>
    RustLib.instance.api
        .crateApiSettingsSetGlobalNotifications(globalEnabled: globalEnabled);

Future<void> setRateFetcher({required BigInt walletIndex, String? currency}) =>
    RustLib.instance.api.crateApiSettingsSetRateFetcher(
        walletIndex: walletIndex, currency: currency);

Future<void> setWalletEns(
        {required BigInt walletIndex, required bool ensEnabled}) =>
    RustLib.instance.api.crateApiSettingsSetWalletEns(
        walletIndex: walletIndex, ensEnabled: ensEnabled);

Future<void> setWalletIpfsNode({required BigInt walletIndex, String? node}) =>
    RustLib.instance.api.crateApiSettingsSetWalletIpfsNode(
        walletIndex: walletIndex, node: node);

Future<void> setWalletGasControl(
        {required BigInt walletIndex, required bool enabled}) =>
    RustLib.instance.api.crateApiSettingsSetWalletGasControl(
        walletIndex: walletIndex, enabled: enabled);

Future<void> setWalletNodeRanking(
        {required BigInt walletIndex, required bool enabled}) =>
    RustLib.instance.api.crateApiSettingsSetWalletNodeRanking(
        walletIndex: walletIndex, enabled: enabled);

Future<void> setBrowserSettings(
        {required BrowserSettingsInfo browserSettings}) =>
    RustLib.instance.api
        .crateApiSettingsSetBrowserSettings(browserSettings: browserSettings);
