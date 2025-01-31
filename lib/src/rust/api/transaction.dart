// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/gas.dart';
import '../models/transactions/access_list.dart';
import '../models/transactions/base_token.dart';
import '../models/transactions/evm.dart';
import '../models/transactions/history.dart';
import '../models/transactions/request.dart';
import '../models/transactions/scilla.dart';
import '../models/transactions/transaction_metadata.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<TransactionRequestInfo>> getRequestedTransactions(
        {required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiTransactionGetRequestedTransactions(walletIndex: walletIndex);

Future<void> clearRequestedTransactions({required BigInt walletIndex}) =>
    RustLib.instance.api.crateApiTransactionClearRequestedTransactions(
        walletIndex: walletIndex);

Future<void> addRequestedTransactions(
        {required BigInt walletIndex, required TransactionRequestInfo tx}) =>
    RustLib.instance.api.crateApiTransactionAddRequestedTransactions(
        walletIndex: walletIndex, tx: tx);

Future<HistoricalTransactionInfo> signSendTransactions(
        {required BigInt walletIndex,
        required BigInt accountIndex,
        String? password,
        String? passphrase,
        String? sessionCipher,
        required List<String> identifiers,
        required TransactionRequestInfo tx}) =>
    RustLib.instance.api.crateApiTransactionSignSendTransactions(
        walletIndex: walletIndex,
        accountIndex: accountIndex,
        password: password,
        passphrase: passphrase,
        sessionCipher: sessionCipher,
        identifiers: identifiers,
        tx: tx);

Future<List<HistoricalTransactionInfo>> getHistory(
        {required BigInt walletIndex}) =>
    RustLib.instance.api
        .crateApiTransactionGetHistory(walletIndex: walletIndex);

Future<TransactionRequestInfo> createTokenTransfer(
        {required TokenTransferParamsInfo params}) =>
    RustLib.instance.api.crateApiTransactionCreateTokenTransfer(params: params);

Future<GasInfo> caclGasFee({required TransactionRequestInfo params}) =>
    RustLib.instance.api.crateApiTransactionCaclGasFee(params: params);

class TokenTransferParamsInfo {
  final BigInt walletIndex;
  final BigInt accountIndex;
  final BigInt tokenIndex;
  final String amount;
  final String recipient;

  const TokenTransferParamsInfo({
    required this.walletIndex,
    required this.accountIndex,
    required this.tokenIndex,
    required this.amount,
    required this.recipient,
  });

  @override
  int get hashCode =>
      walletIndex.hashCode ^
      accountIndex.hashCode ^
      tokenIndex.hashCode ^
      amount.hashCode ^
      recipient.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenTransferParamsInfo &&
          runtimeType == other.runtimeType &&
          walletIndex == other.walletIndex &&
          accountIndex == other.accountIndex &&
          tokenIndex == other.tokenIndex &&
          amount == other.amount &&
          recipient == other.recipient;
}
