// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.10.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/account.dart';
import '../models/ftoken.dart';
import '../models/keypair.dart';
import '../models/settings.dart';
import '../models/wallet.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<WalletInfo>> getWallets() =>
    RustLib.instance.api.crateApiWalletGetWallets();

Future<(String, String)> addBip39Wallet(
        {required Bip39AddWalletParams params,
        required WalletSettingsInfo walletSettings,
        required List<FTokenInfo> ftokens}) =>
    RustLib.instance.api.crateApiWalletAddBip39Wallet(
        params: params, walletSettings: walletSettings, ftokens: ftokens);

Future<(String, String)> addSkWallet(
        {required AddSKWalletParams params,
        required WalletSettingsInfo walletSettings,
        required List<FTokenInfo> ftokens}) =>
    RustLib.instance.api.crateApiWalletAddSkWallet(
        params: params, walletSettings: walletSettings, ftokens: ftokens);

Future<void> addNextBip39Account({required AddNextBip39AccountParams params}) =>
    RustLib.instance.api.crateApiWalletAddNextBip39Account(params: params);

Future<void> selectAccount(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiWalletSelectAccount(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<void> changeAccountName(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        required String newName}) =>
    RustLib.instance.api.crateApiWalletChangeAccountName(
        walletIndex: walletIndex, accountIndex: accountIndex, newName: newName);

Future<void> changeWalletName(
        {required BigInt walletIndex, required String newName}) =>
    RustLib.instance.api.crateApiWalletChangeWalletName(
        walletIndex: walletIndex, newName: newName);

Future<void> deleteWallet(
        {required BigInt walletIndex,
        required List<String> identifiers,
        String? password,
        String? sessionCipher}) =>
    RustLib.instance.api.crateApiWalletDeleteWallet(
        walletIndex: walletIndex,
        identifiers: identifiers,
        password: password,
        sessionCipher: sessionCipher);

Future<void> deleteAccount(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiWalletDeleteAccount(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<String?> setBiometric(
        {required BigInt walletIndex,
        required List<String> identifiers,
        required String password,
        String? sessionCipher,
        required String newBiometricType}) =>
    RustLib.instance.api.crateApiWalletSetBiometric(
        walletIndex: walletIndex,
        identifiers: identifiers,
        password: password,
        sessionCipher: sessionCipher,
        newBiometricType: newBiometricType);

Future<KeyPairInfo> revealKeypair(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        required List<String> identifiers,
        required String password,
        String? passphrase}) =>
    RustLib.instance.api.crateApiWalletRevealKeypair(
        walletIndex: walletIndex,
        accountIndex: accountIndex,
        identifiers: identifiers,
        password: password,
        passphrase: passphrase);

Future<String> revealBip39Phrase(
        {required BigInt walletIndex,
        required List<String> identifiers,
        required String password,
        String? passphrase}) =>
    RustLib.instance.api.crateApiWalletRevealBip39Phrase(
        walletIndex: walletIndex,
        identifiers: identifiers,
        password: password,
        passphrase: passphrase);

Future<void> zilliqaSwapChain(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiWalletZilliqaSwapChain(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<(String, String)> zilliqaGetBech32Base16Address(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiWalletZilliqaGetBech32Base16Address(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<List<String>> getZilEthChecksumAddresses(
        {required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiWalletGetZilEthChecksumAddresses(walletIndex: walletIndex);

Future<List<String>> getZilBech32Addresses({required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiWalletGetZilBech32Addresses(walletIndex: walletIndex);

Future<String> zilliqaLegacyBase16ToBech32({required String base16}) =>
    RustLib.instance.api
        .crateApiWalletZilliqaLegacyBase16ToBech32(base16: base16);

Future<String> zilliqaGetNFormat(
        {required BigInt walletIndex, required BigInt accountIndex}) =>
    RustLib.instance.api.crateApiWalletZilliqaGetNFormat(
        walletIndex: walletIndex, accountIndex: accountIndex);

Future<Uint8List> makeKeystoreFile(
        {required BigInt walletIndex,
        required String password,
        required List<String> deviceIndicators}) =>
    RustLib.instance.api.crateApiWalletMakeKeystoreFile(
        walletIndex: walletIndex,
        password: password,
        deviceIndicators: deviceIndicators);

Future<(String, String)> restoreFromKeystore(
        {required List<int> keystoreBytes,
        required List<String> deviceIndicators,
        required String password,
        required String biometricType}) =>
    RustLib.instance.api.crateApiWalletRestoreFromKeystore(
        keystoreBytes: keystoreBytes,
        deviceIndicators: deviceIndicators,
        password: password,
        biometricType: biometricType);

class AddNextBip39AccountParams {
  final BigInt walletIndex;
  final BigInt accountIndex;
  final String name;
  final String passphrase;
  final List<String> identifiers;
  final String? password;
  final String? sessionCipher;

  const AddNextBip39AccountParams({
    required this.walletIndex,
    required this.accountIndex,
    required this.name,
    required this.passphrase,
    required this.identifiers,
    this.password,
    this.sessionCipher,
  });

  @override
  int get hashCode =>
      walletIndex.hashCode ^
      accountIndex.hashCode ^
      name.hashCode ^
      passphrase.hashCode ^
      identifiers.hashCode ^
      password.hashCode ^
      sessionCipher.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddNextBip39AccountParams &&
          runtimeType == other.runtimeType &&
          walletIndex == other.walletIndex &&
          accountIndex == other.accountIndex &&
          name == other.name &&
          passphrase == other.passphrase &&
          identifiers == other.identifiers &&
          password == other.password &&
          sessionCipher == other.sessionCipher;
}

class AddSKWalletParams {
  final String sk;
  final String password;
  final String walletName;
  final String biometricType;
  final List<String> identifiers;
  final BigInt chainHash;

  const AddSKWalletParams({
    required this.sk,
    required this.password,
    required this.walletName,
    required this.biometricType,
    required this.identifiers,
    required this.chainHash,
  });

  @override
  int get hashCode =>
      sk.hashCode ^
      password.hashCode ^
      walletName.hashCode ^
      biometricType.hashCode ^
      identifiers.hashCode ^
      chainHash.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddSKWalletParams &&
          runtimeType == other.runtimeType &&
          sk == other.sk &&
          password == other.password &&
          walletName == other.walletName &&
          biometricType == other.biometricType &&
          identifiers == other.identifiers &&
          chainHash == other.chainHash;
}

class Bip39AddWalletParams {
  final String password;
  final String mnemonicStr;
  final bool mnemonicCheck;
  final List<(BigInt, String)> accounts;
  final String passphrase;
  final String walletName;
  final String biometricType;
  final BigInt chainHash;
  final List<String> identifiers;

  const Bip39AddWalletParams({
    required this.password,
    required this.mnemonicStr,
    required this.mnemonicCheck,
    required this.accounts,
    required this.passphrase,
    required this.walletName,
    required this.biometricType,
    required this.chainHash,
    required this.identifiers,
  });

  @override
  int get hashCode =>
      password.hashCode ^
      mnemonicStr.hashCode ^
      mnemonicCheck.hashCode ^
      accounts.hashCode ^
      passphrase.hashCode ^
      walletName.hashCode ^
      biometricType.hashCode ^
      chainHash.hashCode ^
      identifiers.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bip39AddWalletParams &&
          runtimeType == other.runtimeType &&
          password == other.password &&
          mnemonicStr == other.mnemonicStr &&
          mnemonicCheck == other.mnemonicCheck &&
          accounts == other.accounts &&
          passphrase == other.passphrase &&
          walletName == other.walletName &&
          biometricType == other.biometricType &&
          chainHash == other.chainHash &&
          identifiers == other.identifiers;
}
