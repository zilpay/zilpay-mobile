// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../models/qrcode.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<String> genSvgQrcode(
        {required String data, required QrConfigInfo config}) =>
    RustLib.instance.api.crateApiQrcodeGenSvgQrcode(data: data, config: config);

Future<Uint8List> genPngQrcode(
        {required String data, required QrConfigInfo config}) =>
    RustLib.instance.api.crateApiQrcodeGenPngQrcode(data: data, config: config);

Future<QRcodeScanResultInfo> parseQrcodeStr({required String data}) =>
    RustLib.instance.api.crateApiQrcodeParseQrcodeStr(data: data);
