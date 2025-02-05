// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.7.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class AccessListItem {
  final String address;
  final List<String> storageKeys;

  const AccessListItem({
    required this.address,
    required this.storageKeys,
  });

  @override
  int get hashCode => address.hashCode ^ storageKeys.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessListItem &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          storageKeys == other.storageKeys;
}
