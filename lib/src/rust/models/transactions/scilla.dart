// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.7.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class TransactionRequestScilla {
  final int chainId;
  final BigInt nonce;
  final BigInt gasPrice;
  final BigInt gasLimit;
  final String toAddr;
  final BigInt amount;
  final String code;
  final String data;

  const TransactionRequestScilla({
    required this.chainId,
    required this.nonce,
    required this.gasPrice,
    required this.gasLimit,
    required this.toAddr,
    required this.amount,
    required this.code,
    required this.data,
  });

  @override
  int get hashCode =>
      chainId.hashCode ^
      nonce.hashCode ^
      gasPrice.hashCode ^
      gasLimit.hashCode ^
      toAddr.hashCode ^
      amount.hashCode ^
      code.hashCode ^
      data.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionRequestScilla &&
          runtimeType == other.runtimeType &&
          chainId == other.chainId &&
          nonce == other.nonce &&
          gasPrice == other.gasPrice &&
          gasLimit == other.gasLimit &&
          toAddr == other.toAddr &&
          amount == other.amount &&
          code == other.code &&
          data == other.data;
}
