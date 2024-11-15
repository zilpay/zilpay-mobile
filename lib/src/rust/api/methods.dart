// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<String> genBip39Words({required int count}) =>
    RustLib.instance.api.crateApiMethodsGenBip39Words(count: count);

Future<KeyPair> genKeypair() =>
    RustLib.instance.api.crateApiMethodsGenKeypair();

class KeyPair {
  final String sk;
  final String pk;

  const KeyPair({
    required this.sk,
    required this.pk,
  });

  @override
  int get hashCode => sk.hashCode ^ pk.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyPair &&
          runtimeType == other.runtimeType &&
          sk == other.sk &&
          pk == other.pk;
}
