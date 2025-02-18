// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/auth.dart';
import 'api/backend.dart';
import 'api/book.dart';
import 'api/cache.dart';
import 'api/connections.dart';
import 'api/ledger.dart';
import 'api/methods.dart';
import 'api/provider.dart';
import 'api/qrcode.dart';
import 'api/settings.dart';
import 'api/token.dart';
import 'api/transaction.dart';
import 'api/wallet.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'models/account.dart';
import 'models/background.dart';
import 'models/book.dart';
import 'models/connection.dart';
import 'models/ftoken.dart';
import 'models/gas.dart';
import 'models/keypair.dart';
import 'models/notification.dart';
import 'models/provider.dart';
import 'models/qrcode.dart';
import 'models/settings.dart';
import 'models/transactions/access_list.dart';
import 'models/transactions/base_token.dart';
import 'models/transactions/evm.dart';
import 'models/transactions/history.dart';
import 'models/transactions/request.dart';
import 'models/transactions/scilla.dart';
import 'models/transactions/transaction_metadata.dart';
import 'models/wallet.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  Map<BigInt, String> dco_decode_Map_usize_String(dynamic raw);

  @protected
  Map<BigInt, BackgroundNotificationState>
      dco_decode_Map_usize_background_notification_state(dynamic raw);

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw);

  @protected
  RustStreamSink<BlockEvent> dco_decode_StreamSink_block_event_Sse(dynamic raw);

  @protected
  RustStreamSink<int> dco_decode_StreamSink_i_32_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  BigInt dco_decode_U128(dynamic raw);

  @protected
  AccessListItem dco_decode_access_list_item(dynamic raw);

  @protected
  AccountInfo dco_decode_account_info(dynamic raw);

  @protected
  AddNextBip39AccountParams dco_decode_add_next_bip_39_account_params(
      dynamic raw);

  @protected
  AddSKWalletParams dco_decode_add_sk_wallet_params(dynamic raw);

  @protected
  AddressBookEntryInfo dco_decode_address_book_entry_info(dynamic raw);

  @protected
  BackgroundNotificationState dco_decode_background_notification_state(
      dynamic raw);

  @protected
  BackgroundState dco_decode_background_state(dynamic raw);

  @protected
  BaseTokenInfo dco_decode_base_token_info(dynamic raw);

  @protected
  Bip39AddWalletParams dco_decode_bip_39_add_wallet_params(dynamic raw);

  @protected
  BlockEvent dco_decode_block_event(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  AddNextBip39AccountParams
      dco_decode_box_autoadd_add_next_bip_39_account_params(dynamic raw);

  @protected
  AddSKWalletParams dco_decode_box_autoadd_add_sk_wallet_params(dynamic raw);

  @protected
  BaseTokenInfo dco_decode_box_autoadd_base_token_info(dynamic raw);

  @protected
  Bip39AddWalletParams dco_decode_box_autoadd_bip_39_add_wallet_params(
      dynamic raw);

  @protected
  bool dco_decode_box_autoadd_bool(dynamic raw);

  @protected
  ColorsInfo dco_decode_box_autoadd_colors_info(dynamic raw);

  @protected
  ConnectionInfo dco_decode_box_autoadd_connection_info(dynamic raw);

  @protected
  FTokenInfo dco_decode_box_autoadd_f_token_info(dynamic raw);

  @protected
  LedgerParamsInput dco_decode_box_autoadd_ledger_params_input(dynamic raw);

  @protected
  NetworkConfigInfo dco_decode_box_autoadd_network_config_info(dynamic raw);

  @protected
  QrConfigInfo dco_decode_box_autoadd_qr_config_info(dynamic raw);

  @protected
  TokenTransferParamsInfo dco_decode_box_autoadd_token_transfer_params_info(
      dynamic raw);

  @protected
  TransactionRequestEVM dco_decode_box_autoadd_transaction_request_evm(
      dynamic raw);

  @protected
  TransactionRequestInfo dco_decode_box_autoadd_transaction_request_info(
      dynamic raw);

  @protected
  TransactionRequestScilla dco_decode_box_autoadd_transaction_request_scilla(
      dynamic raw);

  @protected
  BigInt dco_decode_box_autoadd_u_64(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_8(dynamic raw);

  @protected
  WalletSettingsInfo dco_decode_box_autoadd_wallet_settings_info(dynamic raw);

  @protected
  ColorsInfo dco_decode_colors_info(dynamic raw);

  @protected
  ConnectionInfo dco_decode_connection_info(dynamic raw);

  @protected
  ExplorerInfo dco_decode_explorer_info(dynamic raw);

  @protected
  FTokenInfo dco_decode_f_token_info(dynamic raw);

  @protected
  GasFeeHistoryInfo dco_decode_gas_fee_history_info(dynamic raw);

  @protected
  HistoricalTransactionInfo dco_decode_historical_transaction_info(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  KeyPairInfo dco_decode_key_pair_info(dynamic raw);

  @protected
  LedgerParamsInput dco_decode_ledger_params_input(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<AccessListItem> dco_decode_list_access_list_item(dynamic raw);

  @protected
  List<AccountInfo> dco_decode_list_account_info(dynamic raw);

  @protected
  List<AddressBookEntryInfo> dco_decode_list_address_book_entry_info(
      dynamic raw);

  @protected
  List<ConnectionInfo> dco_decode_list_connection_info(dynamic raw);

  @protected
  List<ExplorerInfo> dco_decode_list_explorer_info(dynamic raw);

  @protected
  List<FTokenInfo> dco_decode_list_f_token_info(dynamic raw);

  @protected
  List<HistoricalTransactionInfo> dco_decode_list_historical_transaction_info(
      dynamic raw);

  @protected
  List<NetworkConfigInfo> dco_decode_list_network_config_info(dynamic raw);

  @protected
  Uint16List dco_decode_list_prim_u_16_strict(dynamic raw);

  @protected
  Uint64List dco_decode_list_prim_u_64_strict(dynamic raw);

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
  List<WalletInfo> dco_decode_list_wallet_info(dynamic raw);

  @protected
  NetworkConfigInfo dco_decode_network_config_info(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  BigInt? dco_decode_opt_U128(dynamic raw);

  @protected
  BaseTokenInfo? dco_decode_opt_box_autoadd_base_token_info(dynamic raw);

  @protected
  bool? dco_decode_opt_box_autoadd_bool(dynamic raw);

  @protected
  ColorsInfo? dco_decode_opt_box_autoadd_colors_info(dynamic raw);

  @protected
  TransactionRequestEVM? dco_decode_opt_box_autoadd_transaction_request_evm(
      dynamic raw);

  @protected
  TransactionRequestScilla?
      dco_decode_opt_box_autoadd_transaction_request_scilla(dynamic raw);

  @protected
  BigInt? dco_decode_opt_box_autoadd_u_64(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_8(dynamic raw);

  @protected
  List<String>? dco_decode_opt_list_String(dynamic raw);

  @protected
  List<AccessListItem>? dco_decode_opt_list_access_list_item(dynamic raw);

  @protected
  Uint8List? dco_decode_opt_list_prim_u_8_strict(dynamic raw);

  @protected
  QRcodeScanResultInfo dco_decode_q_rcode_scan_result_info(dynamic raw);

  @protected
  QrConfigInfo dco_decode_qr_config_info(dynamic raw);

  @protected
  (Uint8List, String) dco_decode_record_list_prim_u_8_strict_string(
      dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  (BigInt, BackgroundNotificationState)
      dco_decode_record_usize_background_notification_state(dynamic raw);

  @protected
  (BigInt, String) dco_decode_record_usize_string(dynamic raw);

  @protected
  RequiredTxParamsInfo dco_decode_required_tx_params_info(dynamic raw);

  @protected
  TokenTransferParamsInfo dco_decode_token_transfer_params_info(dynamic raw);

  @protected
  TransactionMetadataInfo dco_decode_transaction_metadata_info(dynamic raw);

  @protected
  TransactionRequestEVM dco_decode_transaction_request_evm(dynamic raw);

  @protected
  TransactionRequestInfo dco_decode_transaction_request_info(dynamic raw);

  @protected
  TransactionRequestScilla dco_decode_transaction_request_scilla(dynamic raw);

  @protected
  TransactionStatusInfo dco_decode_transaction_status_info(dynamic raw);

  @protected
  int dco_decode_u_16(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  BigInt dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  WalletArgonParamsInfo dco_decode_wallet_argon_params_info(dynamic raw);

  @protected
  WalletInfo dco_decode_wallet_info(dynamic raw);

  @protected
  WalletSettingsInfo dco_decode_wallet_settings_info(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  Map<BigInt, String> sse_decode_Map_usize_String(SseDeserializer deserializer);

  @protected
  Map<BigInt, BackgroundNotificationState>
      sse_decode_Map_usize_background_notification_state(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<BlockEvent> sse_decode_StreamSink_block_event_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<int> sse_decode_StreamSink_i_32_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_U128(SseDeserializer deserializer);

  @protected
  AccessListItem sse_decode_access_list_item(SseDeserializer deserializer);

  @protected
  AccountInfo sse_decode_account_info(SseDeserializer deserializer);

  @protected
  AddNextBip39AccountParams sse_decode_add_next_bip_39_account_params(
      SseDeserializer deserializer);

  @protected
  AddSKWalletParams sse_decode_add_sk_wallet_params(
      SseDeserializer deserializer);

  @protected
  AddressBookEntryInfo sse_decode_address_book_entry_info(
      SseDeserializer deserializer);

  @protected
  BackgroundNotificationState sse_decode_background_notification_state(
      SseDeserializer deserializer);

  @protected
  BackgroundState sse_decode_background_state(SseDeserializer deserializer);

  @protected
  BaseTokenInfo sse_decode_base_token_info(SseDeserializer deserializer);

  @protected
  Bip39AddWalletParams sse_decode_bip_39_add_wallet_params(
      SseDeserializer deserializer);

  @protected
  BlockEvent sse_decode_block_event(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  AddNextBip39AccountParams
      sse_decode_box_autoadd_add_next_bip_39_account_params(
          SseDeserializer deserializer);

  @protected
  AddSKWalletParams sse_decode_box_autoadd_add_sk_wallet_params(
      SseDeserializer deserializer);

  @protected
  BaseTokenInfo sse_decode_box_autoadd_base_token_info(
      SseDeserializer deserializer);

  @protected
  Bip39AddWalletParams sse_decode_box_autoadd_bip_39_add_wallet_params(
      SseDeserializer deserializer);

  @protected
  bool sse_decode_box_autoadd_bool(SseDeserializer deserializer);

  @protected
  ColorsInfo sse_decode_box_autoadd_colors_info(SseDeserializer deserializer);

  @protected
  ConnectionInfo sse_decode_box_autoadd_connection_info(
      SseDeserializer deserializer);

  @protected
  FTokenInfo sse_decode_box_autoadd_f_token_info(SseDeserializer deserializer);

  @protected
  LedgerParamsInput sse_decode_box_autoadd_ledger_params_input(
      SseDeserializer deserializer);

  @protected
  NetworkConfigInfo sse_decode_box_autoadd_network_config_info(
      SseDeserializer deserializer);

  @protected
  QrConfigInfo sse_decode_box_autoadd_qr_config_info(
      SseDeserializer deserializer);

  @protected
  TokenTransferParamsInfo sse_decode_box_autoadd_token_transfer_params_info(
      SseDeserializer deserializer);

  @protected
  TransactionRequestEVM sse_decode_box_autoadd_transaction_request_evm(
      SseDeserializer deserializer);

  @protected
  TransactionRequestInfo sse_decode_box_autoadd_transaction_request_info(
      SseDeserializer deserializer);

  @protected
  TransactionRequestScilla sse_decode_box_autoadd_transaction_request_scilla(
      SseDeserializer deserializer);

  @protected
  BigInt sse_decode_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  WalletSettingsInfo sse_decode_box_autoadd_wallet_settings_info(
      SseDeserializer deserializer);

  @protected
  ColorsInfo sse_decode_colors_info(SseDeserializer deserializer);

  @protected
  ConnectionInfo sse_decode_connection_info(SseDeserializer deserializer);

  @protected
  ExplorerInfo sse_decode_explorer_info(SseDeserializer deserializer);

  @protected
  FTokenInfo sse_decode_f_token_info(SseDeserializer deserializer);

  @protected
  GasFeeHistoryInfo sse_decode_gas_fee_history_info(
      SseDeserializer deserializer);

  @protected
  HistoricalTransactionInfo sse_decode_historical_transaction_info(
      SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  KeyPairInfo sse_decode_key_pair_info(SseDeserializer deserializer);

  @protected
  LedgerParamsInput sse_decode_ledger_params_input(
      SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<AccessListItem> sse_decode_list_access_list_item(
      SseDeserializer deserializer);

  @protected
  List<AccountInfo> sse_decode_list_account_info(SseDeserializer deserializer);

  @protected
  List<AddressBookEntryInfo> sse_decode_list_address_book_entry_info(
      SseDeserializer deserializer);

  @protected
  List<ConnectionInfo> sse_decode_list_connection_info(
      SseDeserializer deserializer);

  @protected
  List<ExplorerInfo> sse_decode_list_explorer_info(
      SseDeserializer deserializer);

  @protected
  List<FTokenInfo> sse_decode_list_f_token_info(SseDeserializer deserializer);

  @protected
  List<HistoricalTransactionInfo> sse_decode_list_historical_transaction_info(
      SseDeserializer deserializer);

  @protected
  List<NetworkConfigInfo> sse_decode_list_network_config_info(
      SseDeserializer deserializer);

  @protected
  Uint16List sse_decode_list_prim_u_16_strict(SseDeserializer deserializer);

  @protected
  Uint64List sse_decode_list_prim_u_64_strict(SseDeserializer deserializer);

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
  List<WalletInfo> sse_decode_list_wallet_info(SseDeserializer deserializer);

  @protected
  NetworkConfigInfo sse_decode_network_config_info(
      SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  BigInt? sse_decode_opt_U128(SseDeserializer deserializer);

  @protected
  BaseTokenInfo? sse_decode_opt_box_autoadd_base_token_info(
      SseDeserializer deserializer);

  @protected
  bool? sse_decode_opt_box_autoadd_bool(SseDeserializer deserializer);

  @protected
  ColorsInfo? sse_decode_opt_box_autoadd_colors_info(
      SseDeserializer deserializer);

  @protected
  TransactionRequestEVM? sse_decode_opt_box_autoadd_transaction_request_evm(
      SseDeserializer deserializer);

  @protected
  TransactionRequestScilla?
      sse_decode_opt_box_autoadd_transaction_request_scilla(
          SseDeserializer deserializer);

  @protected
  BigInt? sse_decode_opt_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  List<String>? sse_decode_opt_list_String(SseDeserializer deserializer);

  @protected
  List<AccessListItem>? sse_decode_opt_list_access_list_item(
      SseDeserializer deserializer);

  @protected
  Uint8List? sse_decode_opt_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  QRcodeScanResultInfo sse_decode_q_rcode_scan_result_info(
      SseDeserializer deserializer);

  @protected
  QrConfigInfo sse_decode_qr_config_info(SseDeserializer deserializer);

  @protected
  (Uint8List, String) sse_decode_record_list_prim_u_8_strict_string(
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
  RequiredTxParamsInfo sse_decode_required_tx_params_info(
      SseDeserializer deserializer);

  @protected
  TokenTransferParamsInfo sse_decode_token_transfer_params_info(
      SseDeserializer deserializer);

  @protected
  TransactionMetadataInfo sse_decode_transaction_metadata_info(
      SseDeserializer deserializer);

  @protected
  TransactionRequestEVM sse_decode_transaction_request_evm(
      SseDeserializer deserializer);

  @protected
  TransactionRequestInfo sse_decode_transaction_request_info(
      SseDeserializer deserializer);

  @protected
  TransactionRequestScilla sse_decode_transaction_request_scilla(
      SseDeserializer deserializer);

  @protected
  TransactionStatusInfo sse_decode_transaction_status_info(
      SseDeserializer deserializer);

  @protected
  int sse_decode_u_16(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  WalletArgonParamsInfo sse_decode_wallet_argon_params_info(
      SseDeserializer deserializer);

  @protected
  WalletInfo sse_decode_wallet_info(SseDeserializer deserializer);

  @protected
  WalletSettingsInfo sse_decode_wallet_settings_info(
      SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void sse_encode_Map_usize_String(
      Map<BigInt, String> self, SseSerializer serializer);

  @protected
  void sse_encode_Map_usize_background_notification_state(
      Map<BigInt, BackgroundNotificationState> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_block_event_Sse(
      RustStreamSink<BlockEvent> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_i_32_Sse(
      RustStreamSink<int> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_U128(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_access_list_item(
      AccessListItem self, SseSerializer serializer);

  @protected
  void sse_encode_account_info(AccountInfo self, SseSerializer serializer);

  @protected
  void sse_encode_add_next_bip_39_account_params(
      AddNextBip39AccountParams self, SseSerializer serializer);

  @protected
  void sse_encode_add_sk_wallet_params(
      AddSKWalletParams self, SseSerializer serializer);

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
  void sse_encode_base_token_info(BaseTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_bip_39_add_wallet_params(
      Bip39AddWalletParams self, SseSerializer serializer);

  @protected
  void sse_encode_block_event(BlockEvent self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_add_next_bip_39_account_params(
      AddNextBip39AccountParams self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_add_sk_wallet_params(
      AddSKWalletParams self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_base_token_info(
      BaseTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_bip_39_add_wallet_params(
      Bip39AddWalletParams self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_colors_info(
      ColorsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_connection_info(
      ConnectionInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_f_token_info(
      FTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_ledger_params_input(
      LedgerParamsInput self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_network_config_info(
      NetworkConfigInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_qr_config_info(
      QrConfigInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_token_transfer_params_info(
      TokenTransferParamsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_transaction_request_evm(
      TransactionRequestEVM self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_transaction_request_info(
      TransactionRequestInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_transaction_request_scilla(
      TransactionRequestScilla self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_wallet_settings_info(
      WalletSettingsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_colors_info(ColorsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_connection_info(
      ConnectionInfo self, SseSerializer serializer);

  @protected
  void sse_encode_explorer_info(ExplorerInfo self, SseSerializer serializer);

  @protected
  void sse_encode_f_token_info(FTokenInfo self, SseSerializer serializer);

  @protected
  void sse_encode_gas_fee_history_info(
      GasFeeHistoryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_historical_transaction_info(
      HistoricalTransactionInfo self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_key_pair_info(KeyPairInfo self, SseSerializer serializer);

  @protected
  void sse_encode_ledger_params_input(
      LedgerParamsInput self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_access_list_item(
      List<AccessListItem> self, SseSerializer serializer);

  @protected
  void sse_encode_list_account_info(
      List<AccountInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_address_book_entry_info(
      List<AddressBookEntryInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_connection_info(
      List<ConnectionInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_explorer_info(
      List<ExplorerInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_f_token_info(
      List<FTokenInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_historical_transaction_info(
      List<HistoricalTransactionInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_network_config_info(
      List<NetworkConfigInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_16_strict(
      Uint16List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_64_strict(
      Uint64List self, SseSerializer serializer);

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
  void sse_encode_list_wallet_info(
      List<WalletInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_network_config_info(
      NetworkConfigInfo self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_U128(BigInt? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_base_token_info(
      BaseTokenInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_bool(bool? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_colors_info(
      ColorsInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_transaction_request_evm(
      TransactionRequestEVM? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_transaction_request_scilla(
      TransactionRequestScilla? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_64(BigInt? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_8(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_String(List<String>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_access_list_item(
      List<AccessListItem>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_prim_u_8_strict(
      Uint8List? self, SseSerializer serializer);

  @protected
  void sse_encode_q_rcode_scan_result_info(
      QRcodeScanResultInfo self, SseSerializer serializer);

  @protected
  void sse_encode_qr_config_info(QrConfigInfo self, SseSerializer serializer);

  @protected
  void sse_encode_record_list_prim_u_8_strict_string(
      (Uint8List, String) self, SseSerializer serializer);

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
  void sse_encode_required_tx_params_info(
      RequiredTxParamsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_token_transfer_params_info(
      TokenTransferParamsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_metadata_info(
      TransactionMetadataInfo self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_request_evm(
      TransactionRequestEVM self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_request_info(
      TransactionRequestInfo self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_request_scilla(
      TransactionRequestScilla self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_status_info(
      TransactionStatusInfo self, SseSerializer serializer);

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_argon_params_info(
      WalletArgonParamsInfo self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_info(WalletInfo self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_settings_info(
      WalletSettingsInfo self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {}
