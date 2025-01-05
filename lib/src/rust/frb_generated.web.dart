// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/auth.dart';
import 'api/backend.dart';
import 'api/book.dart';
import 'api/connections.dart';
import 'api/ledger.dart';
import 'api/methods.dart';
import 'api/settings.dart';
import 'api/token.dart';
import 'api/wallet.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'models/background.dart';
import 'models/book.dart';
import 'models/connection.dart';
import 'models/ftoken.dart';
import 'models/keypair.dart';
import 'models/notification.dart';
import 'models/wallet.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_WalletInfoPtr =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  WalletInfo
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  Map<BigInt, String> dco_decode_Map_usize_String(dynamic raw);

  @protected
  Map<BigInt, BackgroundNotificationState>
      dco_decode_Map_usize_background_notification_state(dynamic raw);

  @protected
  WalletInfo
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  AddressBookEntryInfo dco_decode_address_book_entry_info(dynamic raw);

  @protected
  BackgroundNotificationState dco_decode_background_notification_state(
      dynamic raw);

  @protected
  BackgroundState dco_decode_background_state(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  ColorsInfo dco_decode_box_autoadd_colors_info(dynamic raw);

  @protected
  ConnectionInfo dco_decode_box_autoadd_connection_info(dynamic raw);

  @protected
  ColorsInfo dco_decode_colors_info(dynamic raw);

  @protected
  ConnectionInfo dco_decode_connection_info(dynamic raw);

  @protected
  FTokenInfo dco_decode_f_token_info(dynamic raw);

  @protected
  KeyPairInfo dco_decode_key_pair_info(dynamic raw);

  @protected
  List<WalletInfo>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<AddressBookEntryInfo> dco_decode_list_address_book_entry_info(
      dynamic raw);

  @protected
  List<ConnectionInfo> dco_decode_list_connection_info(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  Uint64List dco_decode_list_prim_usize_strict(dynamic raw);

  @protected
  List<(BigInt, BackgroundNotificationState)>
      dco_decode_list_record_usize_background_notification_state(dynamic raw);

  @protected
  List<(BigInt, String)> dco_decode_list_record_usize_string(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  ColorsInfo? dco_decode_opt_box_autoadd_colors_info(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  (BigInt, BackgroundNotificationState)
      dco_decode_record_usize_background_notification_state(dynamic raw);

  @protected
  (BigInt, String) dco_decode_record_usize_string(dynamic raw);

  @protected
  BigInt dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  Map<BigInt, String> sse_decode_Map_usize_String(SseDeserializer deserializer);

  @protected
  Map<BigInt, BackgroundNotificationState>
      sse_decode_Map_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  AddressBookEntryInfo sse_decode_address_book_entry_info(
      SseDeserializer deserializer);

  @protected
  BackgroundNotificationState sse_decode_background_notification_state(
      SseDeserializer deserializer);

  @protected
  BackgroundState sse_decode_background_state(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  ColorsInfo sse_decode_box_autoadd_colors_info(SseDeserializer deserializer);

  @protected
  ConnectionInfo sse_decode_box_autoadd_connection_info(
      SseDeserializer deserializer);

  @protected
  ColorsInfo sse_decode_colors_info(SseDeserializer deserializer);

  @protected
  ConnectionInfo sse_decode_connection_info(SseDeserializer deserializer);

  @protected
  FTokenInfo sse_decode_f_token_info(SseDeserializer deserializer);

  @protected
  KeyPairInfo sse_decode_key_pair_info(SseDeserializer deserializer);

  @protected
  List<WalletInfo>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<AddressBookEntryInfo> sse_decode_list_address_book_entry_info(
      SseDeserializer deserializer);

  @protected
  List<ConnectionInfo> sse_decode_list_connection_info(
      SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  Uint64List sse_decode_list_prim_usize_strict(SseDeserializer deserializer);

  @protected
  List<(BigInt, BackgroundNotificationState)>
      sse_decode_list_record_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  List<(BigInt, String)> sse_decode_list_record_usize_string(
      SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  ColorsInfo? sse_decode_opt_box_autoadd_colors_info(
      SseDeserializer deserializer);

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
  BigInt sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void sse_encode_Map_usize_String(
      Map<BigInt, String> self, SseSerializer serializer);

  @protected
  void sse_encode_Map_usize_background_notification_state(
      Map<BigInt, BackgroundNotificationState> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_address_book_entry_info(
      AddressBookEntryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_background_notification_state(
      BackgroundNotificationState self, SseSerializer serializer);

  @protected
  void sse_encode_background_state(
      BackgroundState self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_colors_info(
      ColorsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_connection_info(
      ConnectionInfo self, SseSerializer serializer);

  @protected
  void sse_encode_colors_info(ColorsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_connection_info(
      ConnectionInfo self, SseSerializer serializer);

  @protected
  void sse_encode_f_token_info(FTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_key_pair_info(KeyPairInfo self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          List<WalletInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_address_book_entry_info(
      List<AddressBookEntryInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_connection_info(
      List<ConnectionInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_usize_strict(
      Uint64List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_usize_background_notification_state(
      List<(BigInt, BackgroundNotificationState)> self,
      SseSerializer serializer);

  @protected
  void sse_encode_list_record_usize_string(
      List<(BigInt, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_colors_info(
      ColorsInfo? self, SseSerializer serializer);

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
  void sse_encode_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr);
}
