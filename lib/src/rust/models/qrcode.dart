// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class QRcodeScanResultInfo {
  final String recipient;
  final String? provider;
  final String? tokenAddress;
  final String? amount;

  const QRcodeScanResultInfo({
    required this.recipient,
    this.provider,
    this.tokenAddress,
    this.amount,
  });

  @override
  int get hashCode =>
      recipient.hashCode ^
      provider.hashCode ^
      tokenAddress.hashCode ^
      amount.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRcodeScanResultInfo &&
          runtimeType == other.runtimeType &&
          recipient == other.recipient &&
          provider == other.provider &&
          tokenAddress == other.tokenAddress &&
          amount == other.amount;
}

class QrConfigInfo {
  final int size;
  final bool gapless;
  final int color;
  final int eyeShape;
  final int dataModuleShape;

  const QrConfigInfo({
    required this.size,
    required this.gapless,
    required this.color,
    required this.eyeShape,
    required this.dataModuleShape,
  });

  @override
  int get hashCode =>
      size.hashCode ^
      gapless.hashCode ^
      color.hashCode ^
      eyeShape.hashCode ^
      dataModuleShape.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrConfigInfo &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          gapless == other.gapless &&
          color == other.color &&
          eyeShape == other.eyeShape &&
          dataModuleShape == other.dataModuleShape;
}
