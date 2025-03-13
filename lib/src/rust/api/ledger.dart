// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/ftoken.dart';
import '../models/settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<(String, String)> addLedgerWallet(
        {required LedgerParamsInput params,
        required WalletSettingsInfo walletSettings,
        required List<FTokenInfo> ftokens}) =>
    RustLib.instance.api.crateApiLedgerAddLedgerWallet(
        params: params, walletSettings: walletSettings, ftokens: ftokens);

Future<void> addLedgerAccount(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        required String name,
        required String pubKey,
        required List<String> identifiers,
        String? sessionCipher}) =>
    RustLib.instance.api.crateApiLedgerAddLedgerAccount(
        walletIndex: walletIndex,
        accountIndex: accountIndex,
        name: name,
        pubKey: pubKey,
        identifiers: identifiers,
        sessionCipher: sessionCipher);

class LedgerParamsInput {
  final String pubKey;
  final BigInt walletIndex;
  final String walletName;
  final String ledgerId;
  final String accountName;
  final String biometricType;
  final List<String> identifiers;
  final BigInt chainHash;

  const LedgerParamsInput({
    required this.pubKey,
    required this.walletIndex,
    required this.walletName,
    required this.ledgerId,
    required this.accountName,
    required this.biometricType,
    required this.identifiers,
    required this.chainHash,
  });

  @override
  int get hashCode =>
      pubKey.hashCode ^
      walletIndex.hashCode ^
      walletName.hashCode ^
      ledgerId.hashCode ^
      accountName.hashCode ^
      biometricType.hashCode ^
      identifiers.hashCode ^
      chainHash.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedgerParamsInput &&
          runtimeType == other.runtimeType &&
          pubKey == other.pubKey &&
          walletIndex == other.walletIndex &&
          walletName == other.walletName &&
          ledgerId == other.ledgerId &&
          accountName == other.accountName &&
          biometricType == other.biometricType &&
          identifiers == other.identifiers &&
          chainHash == other.chainHash;
}
