// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.7.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class AddressBookEntryInfo {
  final String name;
  final String addr;
  final BigInt net;

  const AddressBookEntryInfo({
    required this.name,
    required this.addr,
    required this.net,
  });

  @override
  int get hashCode => name.hashCode ^ addr.hashCode ^ net.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressBookEntryInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          addr == other.addr &&
          net == other.net;
}
