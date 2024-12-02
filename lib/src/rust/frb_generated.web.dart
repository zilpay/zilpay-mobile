// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/backend.dart';
import 'api/methods.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'lib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_ArcBackgroundPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_BackgroundStatePtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_CommonSettingsPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_FTokenPtr => wire
      .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_SerivcePtr => wire
      .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_WalletInfoPtr =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_WalletSettingsPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  ArcBackground
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          dynamic raw);

  @protected
  BackgroundState
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          dynamic raw);

  @protected
  CommonSettings
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          dynamic raw);

  @protected
  FToken
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          dynamic raw);

  @protected
  Serivce
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          dynamic raw);

  @protected
  WalletInfo
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  WalletSettings
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          dynamic raw);

  @protected
  BackgroundState
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          dynamic raw);

  @protected
  Serivce
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          dynamic raw);

  @protected
  WalletInfo
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  BackgroundState
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          dynamic raw);

  @protected
  Serivce
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          dynamic raw);

  @protected
  WalletInfo
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  Map<String, String> dco_decode_Map_String_String(dynamic raw);

  @protected
  ArcBackground
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          dynamic raw);

  @protected
  BackgroundState
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          dynamic raw);

  @protected
  CommonSettings
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          dynamic raw);

  @protected
  FToken
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          dynamic raw);

  @protected
  Serivce
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          dynamic raw);

  @protected
  WalletInfo
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

  @protected
  WalletSettings
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          dynamic raw);

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  AccountInfo dco_decode_account_info(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  FTokenInfo dco_decode_f_token_info(dynamic raw);

  @protected
  KeyPair dco_decode_key_pair(dynamic raw);

  @protected
  List<WalletInfo>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          dynamic raw);

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
  RustStreamSink<String>? dco_decode_opt_StreamSink_String_Sse(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  ArcBackground
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          SseDeserializer deserializer);

  @protected
  BackgroundState
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          SseDeserializer deserializer);

  @protected
  CommonSettings
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          SseDeserializer deserializer);

  @protected
  FToken
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          SseDeserializer deserializer);

  @protected
  Serivce
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  WalletSettings
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          SseDeserializer deserializer);

  @protected
  BackgroundState
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          SseDeserializer deserializer);

  @protected
  Serivce
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  BackgroundState
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          SseDeserializer deserializer);

  @protected
  Serivce
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  Map<String, String> sse_decode_Map_String_String(
      SseDeserializer deserializer);

  @protected
  ArcBackground
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          SseDeserializer deserializer);

  @protected
  BackgroundState
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          SseDeserializer deserializer);

  @protected
  CommonSettings
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          SseDeserializer deserializer);

  @protected
  FToken
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          SseDeserializer deserializer);

  @protected
  Serivce
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          SseDeserializer deserializer);

  @protected
  WalletInfo
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

  @protected
  WalletSettings
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  AccountInfo sse_decode_account_info(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  FTokenInfo sse_decode_f_token_info(SseDeserializer deserializer);

  @protected
  KeyPair sse_decode_key_pair(SseDeserializer deserializer);

  @protected
  List<WalletInfo>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          SseDeserializer deserializer);

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
  RustStreamSink<String>? sse_decode_opt_StreamSink_String_Sse(
      SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

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
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          ArcBackground self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          BackgroundState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          CommonSettings self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          FToken self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          Serivce self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          WalletSettings self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          BackgroundState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          Serivce self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          BackgroundState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          Serivce self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void sse_encode_Map_String_String(
      Map<String, String> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          ArcBackground self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          BackgroundState self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          CommonSettings self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          FToken self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          Serivce self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          WalletInfo self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          WalletSettings self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_account_info(AccountInfo self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_f_token_info(FTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_key_pair(KeyPair self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          List<WalletInfo> self, SseSerializer serializer);

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
  void sse_encode_opt_StreamSink_String_Sse(
      RustStreamSink<String>? self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

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

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
              ptr);

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

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcBackground(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBackgroundState(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCommonSettings(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerFToken(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSerivce(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletInfo(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletSettings(
          int ptr);
}
