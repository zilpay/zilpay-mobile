// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/ftoken.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> syncBalances({required BigInt walletIndex}) =>
    RustLib.instance.api.crateApiTokenSyncBalances(walletIndex: walletIndex);

Future<void> updateRates({required BigInt walletIndex}) =>
    RustLib.instance.api.crateApiTokenUpdateRates(walletIndex: walletIndex);

Future<FTokenInfo> fetchTokenMeta(
        {required String addr, required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiTokenFetchTokenMeta(addr: addr, walletIndex: walletIndex);

Future<List<FTokenInfo>> addFtoken(
        {required FTokenInfo meta, required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiTokenAddFtoken(meta: meta, walletIndex: walletIndex);

Future<void> rmFtoken(
        {required BigInt walletIndex, required BigInt tokenIndex}) =>
    RustLib.instance.api.crateApiTokenRmFtoken(
        walletIndex: walletIndex, tokenIndex: tokenIndex);
