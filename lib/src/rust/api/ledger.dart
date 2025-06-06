// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.10.0.

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

Future<void> updateLedgerAccounts(
        {required BigInt walletIndex,
        required List<(int, String, String)> accounts,
        required bool zilliqaLegacy}) =>
    RustLib.instance.api.crateApiLedgerUpdateLedgerAccounts(
        walletIndex: walletIndex,
        accounts: accounts,
        zilliqaLegacy: zilliqaLegacy);

class LedgerParamsInput {
  final List<(int, String)> pubKeys;
  final BigInt walletIndex;
  final String walletName;
  final String ledgerId;
  final List<String> accountNames;
  final String biometricType;
  final List<String> identifiers;
  final BigInt chainHash;
  final bool zilliqaLegacy;

  const LedgerParamsInput({
    required this.pubKeys,
    required this.walletIndex,
    required this.walletName,
    required this.ledgerId,
    required this.accountNames,
    required this.biometricType,
    required this.identifiers,
    required this.chainHash,
    required this.zilliqaLegacy,
  });

  @override
  int get hashCode =>
      pubKeys.hashCode ^
      walletIndex.hashCode ^
      walletName.hashCode ^
      ledgerId.hashCode ^
      accountNames.hashCode ^
      biometricType.hashCode ^
      identifiers.hashCode ^
      chainHash.hashCode ^
      zilliqaLegacy.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedgerParamsInput &&
          runtimeType == other.runtimeType &&
          pubKeys == other.pubKeys &&
          walletIndex == other.walletIndex &&
          walletName == other.walletName &&
          ledgerId == other.ledgerId &&
          accountNames == other.accountNames &&
          biometricType == other.biometricType &&
          identifiers == other.identifiers &&
          chainHash == other.chainHash &&
          zilliqaLegacy == other.zilliqaLegacy;
}
