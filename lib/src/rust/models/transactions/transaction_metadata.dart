// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'base_token.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class TransactionMetadataInfo {
  final BigInt chainHash;
  final String? hash;
  final String? info;
  final String? icon;
  final String? title;
  final String? signer;
  final BaseTokenInfo? tokenInfo;

  const TransactionMetadataInfo({
    required this.chainHash,
    this.hash,
    this.info,
    this.icon,
    this.title,
    this.signer,
    this.tokenInfo,
  });

  @override
  int get hashCode =>
      chainHash.hashCode ^
      hash.hashCode ^
      info.hashCode ^
      icon.hashCode ^
      title.hashCode ^
      signer.hashCode ^
      tokenInfo.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionMetadataInfo &&
          runtimeType == other.runtimeType &&
          chainHash == other.chainHash &&
          hash == other.hash &&
          info == other.info &&
          icon == other.icon &&
          title == other.title &&
          signer == other.signer &&
          tokenInfo == other.tokenInfo;
}
