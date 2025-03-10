// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

(String, String) intlNumberFormating(
        {required String value,
        required int decimals,
        required String localeStr,
        required String nativeSymbolStr,
        required String convertedSymbolStr,
        required double threshold,
        required bool compact,
        required double converted}) =>
    RustLib.instance.api.crateApiUtilsIntlNumberFormating(
        value: value,
        decimals: decimals,
        localeStr: localeStr,
        nativeSymbolStr: nativeSymbolStr,
        convertedSymbolStr: convertedSymbolStr,
        threshold: threshold,
        compact: compact,
        converted: converted);

Future<List<(String, String)>> getCurrenciesTickets() =>
    RustLib.instance.api.crateApiUtilsGetCurrenciesTickets();
