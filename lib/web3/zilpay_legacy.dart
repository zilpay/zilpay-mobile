import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zilpay/mixins/amount.dart';
import 'package:zilpay/modals/transfer.dart';
import 'package:zilpay/src/rust/api/connections.dart';
import 'package:zilpay/src/rust/api/wallet.dart';
import 'package:zilpay/src/rust/api/provider.dart';
import 'package:zilpay/src/rust/models/connection.dart';
import 'package:zilpay/src/rust/models/transactions/base_token.dart';
import 'package:zilpay/src/rust/models/transactions/request.dart';
import 'package:zilpay/src/rust/models/transactions/scilla.dart';
import 'package:zilpay/src/rust/models/transactions/transaction_metadata.dart';
import 'package:zilpay/state/app_state.dart';
import 'package:zilpay/config/zilliqa_legacy_messages.dart';
import 'package:zilpay/modals/app_connect.dart';
import 'package:zilpay/web3/web3_utils.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class ZilPayLegacyMessage {
  final String type;
  final Map<String, dynamic> payload;
  final String uuid;

  ZilPayLegacyMessage({
    required this.type,
    required this.payload,
    required this.uuid,
  });

  factory ZilPayLegacyMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final uuid = json['uuid'] ?? "";
    final payload = json['payload'] as Map<String, dynamic>? ?? {};

    if (type == null || !ZilliqaLegacyMessages.allTypes.contains(type)) {
      throw FormatException('Invalid or unknown message type: $type');
    }

    return ZilPayLegacyMessage(type: type, payload: payload, uuid: uuid);
  }

  String payloadToJsonString() {
    return jsonEncode(payload);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'payload': payload, 'uuid': uuid};
  }

  @override
  String toString() {
    return 'ZilPayMessage(type: $type, payload: $payload uuid: $uuid)';
  }
}

class ZilPayLegacyTransactionParam {
  final String vname;
  final String type;
  final String value;

  const ZilPayLegacyTransactionParam({
    required this.vname,
    required this.type,
    required this.value,
  });

  factory ZilPayLegacyTransactionParam.fromJson(Map<String, dynamic> json) {
    return ZilPayLegacyTransactionParam(
      vname: json['vname'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, String> toJson() => {
        'vname': vname,
        'type': type,
        'value': value,
      };
}

class ZilPayLegacyHandler {
  final WebViewController webViewController;
  final String initialUrl;

  ZilPayLegacyHandler({
    required this.webViewController,
    required this.initialUrl,
  });

  Future<void> _sendResponse(
      String type, Map<String, Object?> payload, String uuid) async {
    final response =
        ZilPayLegacyMessage(type: type, payload: payload, uuid: uuid).toJson();
    final jsonString = jsonEncode(response);
    await webViewController
        .runJavaScript('window.postMessage($jsonString, "*")');
  }

  Future<void> sendData(AppState appState) async {
    await appState.syncConnections();
    final currentDomain = Uri.parse(initialUrl).host;
    final isConnected =
        Web3Utils.isDomainConnected(currentDomain, appState.connections);
    Map<String, String>? account;

    if (isConnected) {
      final (bech32, base16) = await zilliqaGetBech32Base16Address(
        walletIndex: BigInt.from(appState.selectedWallet),
        accountIndex: appState.wallet!.selectedAccount,
      );
      account = {"base16": base16, "bech32": bech32};
    }

    _sendResponse(
        ZilliqaLegacyMessages.getWalletData,
        {
          'account': account,
          'network': appState.chain?.testnet ?? false ? 'testnet' : 'mainnet',
          'isConnect': isConnected,
          'isEnable': true,
        },
        "");
  }

  void handleStartBlockWorker(AppState appState) {
    // TODO: add worker.
    // Stream<BlockEvent> blockStream =
    //     startBlockWorker(walletIndex: BigInt.from(appState.selectedWallet));

    // blockStream.listen((block) {
    //   if (block.blockNumber != null) {
    //     _sendResponse(ZilliqaLegacyMessages.newBlock,
    //         {'block': block.blockNumber!.toInt()}, "");
    //   }
    // });
  }

  Future<void> handleLegacyZilPayMessage(
    ZilPayLegacyMessage message,
    BuildContext context,
  ) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentDomain = Uri.parse(initialUrl).host;

    switch (message.type) {
      case ZilliqaLegacyMessages.getWalletData:
        await sendData(appState);
        break;

      case ZilliqaLegacyMessages.contentProxyMethod:
        BigInt chainHash = appState.chain?.chainHash ?? BigInt.zero;
        try {
          String jsonRes = await providerReqProxy(
            payload: message.payloadToJsonString(),
            chainHash: chainHash,
          );
          _sendResponse(ZilliqaLegacyMessages.contentProxyResult,
              {'resolve': jsonDecode(jsonRes)}, message.uuid);
        } catch (e) {
          _sendResponse(ZilliqaLegacyMessages.responseToDapp,
              {'reject': e.toString()}, message.uuid);
        }
        break;

      case ZilliqaLegacyMessages.callToSignTx:
        try {
          final appState = Provider.of<AppState>(context, listen: false);
          final tokenIndex =
              appState.wallet!.tokens.indexWhere((t) => t.addrType == 0);

          final amount = BigInt.parse(message.payload['amount'].toString());
          final gasPrice = BigInt.parse(message.payload['gasPrice'].toString());
          final gasLimit = BigInt.parse(message.payload['gasLimit'].toString());
          String toAddr = message.payload['toAddr'] as String;
          String code = message.payload['code'] ?? "";
          String data = message.payload['data'] ?? "";
          String icon = message.payload['icon'] ?? "";
          String title = message.payload['title'] ?? "";

          BigInt chainHash = appState.chain?.chainHash ?? BigInt.zero;
          BigInt chainId = appState.chain?.chainIds.first ?? BigInt.zero;
          BigInt nonce = BigInt.zero;

          final scillaRequest = TransactionRequestScilla(
            chainId: chainId.toInt(),
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            toAddr: toAddr,
            amount: amount,
            code: code,
            data: data,
          );
          BaseTokenInfo tokenInfo = BaseTokenInfo(
            value: amount.toString(),
            symbol: appState.wallet!.tokens[tokenIndex].symbol,
            decimals: appState.wallet!.tokens[tokenIndex].decimals,
          );
          String recipient = toAddr;
          String tokenAmount = adjustAmountToDouble(
                  amount, appState.wallet!.tokens[tokenIndex].decimals)
              .toString();

          final (toAddress, ftAmount, ftMeta) =
              await Web3Utils.fetchTokenMetaLegacyZilliqa(
            data: data,
            contracAddr: toAddr,
            walletIndex: BigInt.from(appState.selectedWallet),
          );

          if (ftMeta != null) {
            tokenAmount =
                adjustAmountToDouble(ftAmount ?? BigInt.zero, ftMeta.decimals)
                    .toString();
            recipient = toAddress!;
            tokenInfo = BaseTokenInfo(
              value: tokenAmount.toString(),
              symbol: ftMeta.symbol,
              decimals: ftMeta.decimals,
            );
          }

          final metadata = TransactionMetadataInfo(
            chainHash: chainHash,
            hash: null,
            info: null,
            icon: icon,
            title: title,
            signer: null,
            tokenInfo: tokenInfo,
          );

          final transactionRequest = TransactionRequestInfo(
            metadata: metadata,
            scilla: scillaRequest,
            evm: null,
          );

          showConfirmTransactionModal(
              context: context,
              tx: transactionRequest,
              to: recipient,
              tokenIndex: tokenIndex,
              amount: tokenAmount,
              onConfirm: (tx) {
                _sendResponse(
                  ZilliqaLegacyMessages.txResult,
                  {
                    'resolve': {
                      'amount': tx.amount.toString(),
                      'code': code,
                      'data': data,
                      'gasLimit': tx.gasLimit.toString(),
                      'gasPrice': tx.gasPrice.toString(),
                      'nonce': tx.nonce.toString(),
                      'priority': false,
                      'pubKey': tx.sender,
                      'signature':
                          tx.transactionHash, // TODO: add sign to hystory
                      'toAddr': tx.recipient,
                      'version': 0,
                      'from': tx.sender,
                      'hash': tx.transactionHash,
                    }
                  },
                  message.uuid,
                );
                Navigator.pop(context);
              },
              onDismiss: () {
                _sendResponse(
                  ZilliqaLegacyMessages.txResult,
                  {'reject': "Rejected by user"},
                  message.uuid,
                );
              });
        } catch (e) {
          debugPrint('Error handling transaction: $e');
          await _sendResponse(
            ZilliqaLegacyMessages.txResult,
            {'reject': e.toString()},
            message.uuid,
          );
        }
        break;

      case ZilliqaLegacyMessages.signMessage:
        debugPrint('Sign message request: ${message.payload}');
        break;

      case ZilliqaLegacyMessages.connectApp:
        await appState.syncConnections();
        final isAlreadyConnected =
            Web3Utils.isDomainConnected(currentDomain, appState.connections);

        if (isAlreadyConnected) {
          final (bech32, base16) = await zilliqaGetBech32Base16Address(
            walletIndex: BigInt.from(appState.selectedWallet),
            accountIndex: appState.wallet!.selectedAccount,
          );
          Map<String, String> account = {"base16": base16, "bech32": bech32};
          _sendResponse(ZilliqaLegacyMessages.responseToDapp,
              {'account': account}, message.uuid);
          return;
        }

        final title = message.payload['title'] as String? ?? 'Unknown App';
        final icon = message.payload['icon'] as String? ?? '';
        final pageInfo = await Web3Utils.extractPageInfo(webViewController);

        if (!context.mounted) return;

        showAppConnectModal(
          context: context,
          title: title,
          uuid: message.uuid,
          iconUrl: icon,
          onDecision: (accepted, selectedIndices) async {
            final walletIndexes = Uint64List.fromList(
                selectedIndices.map((index) => BigInt.from(index)).toList());

            ConnectionInfo connectionInfo = ConnectionInfo(
              domain: currentDomain,
              walletIndexes: walletIndexes,
              favicon: icon,
              title: title,
              description: pageInfo['description'] as String?,
              lastConnected: BigInt.from(DateTime.now().millisecondsSinceEpoch),
              canReadAccounts: true,
              canRequestSignatures: true,
              canSuggestTokens: false,
              canSuggestTransactions: true,
            );
            Map<String, String>? account;

            if (accepted) {
              await createNewConnection(conn: connectionInfo);
              await appState.syncConnections();
              final (bech32, base16) = await zilliqaGetBech32Base16Address(
                walletIndex: BigInt.from(appState.selectedWallet),
                accountIndex: appState.wallet!.selectedAccount,
              );
              account = {"base16": base16, "bech32": bech32};
            }

            await _sendResponse(
                ZilliqaLegacyMessages.responseToDapp,
                {
                  'account': account,
                },
                message.uuid);
          },
        );
        break;

      case ZilliqaLegacyMessages.disconnectApp:
        debugPrint('Disconnect app request: ${message.payload}');
        _sendResponse(ZilliqaLegacyMessages.responseToDapp, {'account': null},
            message.uuid);
        break;

      default:
        debugPrint('Unhandled message type: ${message.type}');
    }
  }
}
