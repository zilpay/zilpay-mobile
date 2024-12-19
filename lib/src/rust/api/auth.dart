// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<bool> tryUnlockWithSession(
        {required String sessionCipher,
        required BigInt walletIndex,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiAuthTryUnlockWithSession(
        sessionCipher: sessionCipher,
        walletIndex: walletIndex,
        identifiers: identifiers);

Future<bool> tryUnlockWithPassword(
        {required String password,
        required BigInt walletIndex,
        required List<String> identifiers}) =>
    RustLib.instance.api.crateApiAuthTryUnlockWithPassword(
        password: password, walletIndex: walletIndex, identifiers: identifiers);
