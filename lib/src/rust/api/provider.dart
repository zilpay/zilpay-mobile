// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/provider.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<NetworkConfigInfo>> getProviders() =>
    RustLib.instance.api.crateApiProviderGetProviders();

Future<NetworkConfigInfo> getProvider({required BigInt chainHash}) =>
    RustLib.instance.api.crateApiProviderGetProvider(chainHash: chainHash);

Future<String> providerReqProxy(
        {required String payload, required BigInt chainHash}) =>
    RustLib.instance.api.crateApiProviderProviderReqProxy(
        payload: payload, chainHash: chainHash);

Future<BigInt> addProvider({required NetworkConfigInfo providerConfig}) =>
    RustLib.instance.api
        .crateApiProviderAddProvider(providerConfig: providerConfig);

Future<void> addProvidersList(
        {required List<NetworkConfigInfo> providerConfig}) =>
    RustLib.instance.api
        .crateApiProviderAddProvidersList(providerConfig: providerConfig);
