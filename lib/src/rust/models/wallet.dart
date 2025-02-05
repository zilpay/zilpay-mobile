// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.7.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'account.dart';
import 'ftoken.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'settings.dart';

class WalletInfo {
  final String walletType;
  final String walletName;
  final String authType;
  final String walletAddress;
  final List<AccountInfo> accounts;
  final BigInt selectedAccount;
  final List<FTokenInfo> tokens;
  final WalletSettingsInfo settings;
  final BigInt defaultChainHash;

  const WalletInfo({
    required this.walletType,
    required this.walletName,
    required this.authType,
    required this.walletAddress,
    required this.accounts,
    required this.selectedAccount,
    required this.tokens,
    required this.settings,
    required this.defaultChainHash,
  });

  @override
  int get hashCode =>
      walletType.hashCode ^
      walletName.hashCode ^
      authType.hashCode ^
      walletAddress.hashCode ^
      accounts.hashCode ^
      selectedAccount.hashCode ^
      tokens.hashCode ^
      settings.hashCode ^
      defaultChainHash.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletInfo &&
          runtimeType == other.runtimeType &&
          walletType == other.walletType &&
          walletName == other.walletName &&
          authType == other.authType &&
          walletAddress == other.walletAddress &&
          accounts == other.accounts &&
          selectedAccount == other.selectedAccount &&
          tokens == other.tokens &&
          settings == other.settings &&
          defaultChainHash == other.defaultChainHash;
}
