// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class AccountInfo {
  final String addr;
  final String name;
  final BigInt chainHash;
  final BigInt index;

  const AccountInfo({
    required this.addr,
    required this.name,
    required this.chainHash,
    required this.index,
  });

  @override
  int get hashCode =>
      addr.hashCode ^ name.hashCode ^ chainHash.hashCode ^ index.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountInfo &&
          runtimeType == other.runtimeType &&
          addr == other.addr &&
          name == other.name &&
          chainHash == other.chainHash &&
          index == other.index;
}
