// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/account.dart';
import 'api/backend.dart';
import 'api/background.dart';
import 'api/ftoken.dart';
import 'api/methods.dart';
import 'api/notification.dart';
import 'api/wallet.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_FTokenPtr => wire
      ._rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFTokenPtr;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  FToken
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          dynamic raw);

  @protected
  Map<String, String> dco_decode_Map_String_String(dynamic raw);

  @protected
  Map<BigInt, BackgroundNotificationState>
      dco_decode_Map_usize_background_notification_state(dynamic raw);

  @protected
  FToken
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          dynamic raw);

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  AccountInfo dco_decode_account_info(dynamic raw);

  @protected
  BackgroundNotificationState dco_decode_background_notification_state(
      dynamic raw);

  @protected
  BackgroundState dco_decode_background_state(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  FTokenInfo dco_decode_f_token_info(dynamic raw);

  @protected
  KeyPair dco_decode_key_pair(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<AccountInfo> dco_decode_list_account_info(dynamic raw);

  @protected
  List<FTokenInfo> dco_decode_list_f_token_info(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  Uint64List dco_decode_list_prim_usize_strict(dynamic raw);

  @protected
  List<(String, String)> dco_decode_list_record_string_string(dynamic raw);

  @protected
  List<(BigInt, BackgroundNotificationState)>
      dco_decode_list_record_usize_background_notification_state(dynamic raw);

  @protected
  List<(BigInt, String)> dco_decode_list_record_usize_string(dynamic raw);

  @protected
  List<WalletInfo> dco_decode_list_wallet_info(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  (BigInt, BackgroundNotificationState)
      dco_decode_record_usize_background_notification_state(dynamic raw);

  @protected
  (BigInt, String) dco_decode_record_usize_string(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  WalletInfo dco_decode_wallet_info(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  FToken
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          SseDeserializer deserializer);

  @protected
  Map<String, String> sse_decode_Map_String_String(
      SseDeserializer deserializer);

  @protected
  Map<BigInt, BackgroundNotificationState>
      sse_decode_Map_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  FToken
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  AccountInfo sse_decode_account_info(SseDeserializer deserializer);

  @protected
  BackgroundNotificationState sse_decode_background_notification_state(
      SseDeserializer deserializer);

  @protected
  BackgroundState sse_decode_background_state(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  FTokenInfo sse_decode_f_token_info(SseDeserializer deserializer);

  @protected
  KeyPair sse_decode_key_pair(SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<AccountInfo> sse_decode_list_account_info(SseDeserializer deserializer);

  @protected
  List<FTokenInfo> sse_decode_list_f_token_info(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  Uint64List sse_decode_list_prim_usize_strict(SseDeserializer deserializer);

  @protected
  List<(String, String)> sse_decode_list_record_string_string(
      SseDeserializer deserializer);

  @protected
  List<(BigInt, BackgroundNotificationState)>
      sse_decode_list_record_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  List<(BigInt, String)> sse_decode_list_record_usize_string(
      SseDeserializer deserializer);

  @protected
  List<WalletInfo> sse_decode_list_wallet_info(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

  @protected
  (BigInt, BackgroundNotificationState)
      sse_decode_record_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  (BigInt, String) sse_decode_record_usize_string(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  WalletInfo sse_decode_wallet_info(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          FToken self, SseSerializer serializer);

  @protected
  void sse_encode_Map_String_String(
      Map<String, String> self, SseSerializer serializer);

  @protected
  void sse_encode_Map_usize_background_notification_state(
      Map<BigInt, BackgroundNotificationState> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          FToken self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_account_info(AccountInfo self, SseSerializer serializer);

  @protected
  void sse_encode_background_notification_state(
      BackgroundNotificationState self, SseSerializer serializer);

  @protected
  void sse_encode_background_state(
      BackgroundState self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_f_token_info(FTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_key_pair(KeyPair self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_account_info(
      List<AccountInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_f_token_info(
      List<FTokenInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_usize_strict(
      Uint64List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_string(
      List<(String, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_usize_background_notification_state(
      List<(BigInt, BackgroundNotificationState)> self,
      SseSerializer serializer);

  @protected
  void sse_encode_list_record_usize_string(
      List<(BigInt, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_wallet_info(
      List<WalletInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

  @protected
  void sse_encode_record_usize_background_notification_state(
      (BigInt, BackgroundNotificationState) self, SseSerializer serializer);

  @protected
  void sse_encode_record_usize_string(
      (BigInt, String) self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_info(WalletInfo self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  factory RustLibWire.fromExternalLibrary(ExternalLibrary lib) =>
      RustLibWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustLibWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
      ptr,
    );
  }

  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFTokenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_zilpay_rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken');
  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken =
      _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFTokenPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
      ptr,
    );
  }

  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFTokenPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_zilpay_rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken');
  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken =
      _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFTokenPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();
}
