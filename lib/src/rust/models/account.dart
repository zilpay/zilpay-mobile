// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.10.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class AccountInfo {
  final String addr;
  final int addrType;
  final String name;
  final String pubKey;
  final BigInt chainHash;
  final BigInt chainId;
  final int slip44;
  final BigInt index;

  const AccountInfo({
    required this.addr,
    required this.addrType,
    required this.name,
    required this.pubKey,
    required this.chainHash,
    required this.chainId,
    required this.slip44,
    required this.index,
  });

  @override
  int get hashCode =>
      addr.hashCode ^
      addrType.hashCode ^
      name.hashCode ^
      pubKey.hashCode ^
      chainHash.hashCode ^
      chainId.hashCode ^
      slip44.hashCode ^
      index.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountInfo &&
          runtimeType == other.runtimeType &&
          addr == other.addr &&
          addrType == other.addrType &&
          name == other.name &&
          pubKey == other.pubKey &&
          chainHash == other.chainHash &&
          chainId == other.chainId &&
          slip44 == other.slip44 &&
          index == other.index;
}
