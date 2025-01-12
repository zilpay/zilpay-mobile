import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zilpay/components/custom_app_bar.dart';
import 'package:zilpay/components/tile_button.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/mixins/qrcode.dart';
import 'package:zilpay/src/rust/models/ftoken.dart';
import 'package:zilpay/src/rust/models/provider.dart';
import 'package:zilpay/state/app_state.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  bool isCopied = false;
  bool isPressedToken = false;
  String amount = "0";

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleCopy(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    setState(() {
      isCopied = true;
    });

    await Future<void>.delayed(const Duration(seconds: 3));

    setState(() {
      isCopied = false;
    });
  }

  void handlePressedChanged(bool pressed) {
    setState(() {
      isPressedToken = pressed;
    });
  }

  void handleSetAmount() {
    // Implement set amount functionality
  }

  void handleSelectToken() {
    // Implement token selection logic here
    debugPrint('Token selection pressed');
  }

  Future<void> handleShare(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final theme = appState.currentTheme;
    final provider = appState.state
        .providers[(appState.account?.providerIndex ?? BigInt.zero).toInt()];
    final token = appState.wallet?.tokens[0];
    final address = appState.account?.addr ?? "";
    final networkName = provider.networkName;
    final tokenSymbol = token?.symbol ?? "";

    try {
      // Get RenderBox for sharePositionOrigin (required for iPad)
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box!.localToGlobal(Offset.zero) & box.size;

      // Generate QR code as image
      final qrPainter = QrPainter(
        data: appState.account?.addr ?? "",
        version: QrVersions.auto,
        gapless: false,
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: theme.primaryPurple,
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: theme.primaryPurple,
        ),
      );

      final imageData = await qrPainter.toImageData(200.0);
      if (imageData == null) {
        throw Exception('Failed to generate QR code');
      }

      final tempDir = await getTemporaryDirectory();
      final file = await File(
              '${tempDir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png')
          .create();
      await file.writeAsBytes(imageData.buffer.asUint8List());

      final shareText = '''My $networkName ($tokenSymbol) address:$address''';
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
        subject: '$networkName Address',
        sharePositionOrigin: sharePositionOrigin,
      );

      if (result.status == ShareResultStatus.success) {
        debugPrint('Successfully shared the address');
      } else if (result.status == ShareResultStatus.dismissed) {
        debugPrint('Share was dismissed');
      }

      try {
        await file.delete();
      } catch (e) {
        debugPrint('Error deleting temporary file: $e');
      }
    } catch (e) {
      debugPrint('Error sharing with QR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);
    final providerIndex = appState.account?.providerIndex ?? BigInt.zero;
    final provider = appState.state.providers[providerIndex.toInt()];
    final token = appState.wallet?.tokens[0];

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
                  child: CustomAppBar(
                    title: 'Receive',
                    onBackPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: adaptivePadding),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/warning.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    theme.warning,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Only send ${provider.networkName}(${token?.symbol}) assets to this address. Other assets will be lost forever.',
                                    style: TextStyle(
                                      color: theme.warning,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTapDown: (_) => handlePressedChanged(true),
                                  onTapUp: (_) => handlePressedChanged(false),
                                  onTapCancel: () =>
                                      handlePressedChanged(false),
                                  onTap: handleSelectToken,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 150),
                                    opacity: isPressedToken ? 0.6 : 1.0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Image.network(
                                              token?.logo ?? "",
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          token?.name ?? "",
                                          style: TextStyle(
                                            color: theme.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "(${token?.name})",
                                          style: TextStyle(
                                            color: theme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (token != null && appState.account != null)
                                  QrImageView(
                                    data: _qrcodeGen(
                                      appState.account!.addr,
                                      token,
                                      provider,
                                    ),
                                    version: QrVersions.auto,
                                    size: 200,
                                    gapless: false,
                                    backgroundColor: Colors.transparent,
                                    dataModuleStyle: QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.circle,
                                      color: theme.primaryPurple,
                                    ),
                                    eyeStyle: QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: theme.primaryPurple,
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Text(
                                  appState.account?.addr ?? "",
                                  style: TextStyle(
                                    color: theme.textSecondary,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TileButton(
                                icon: SvgPicture.asset(
                                  isCopied
                                      ? "assets/icons/check.svg"
                                      : "assets/icons/copy.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    theme.primaryPurple,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                disabled: false,
                                onPressed: () async {
                                  await handleCopy(appState.account!.addr);
                                },
                                backgroundColor: theme.cardBackground,
                                textColor: theme.primaryPurple,
                              ),
                              TileButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/hash.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    theme.primaryPurple,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                disabled: false,
                                onPressed: () {},
                                backgroundColor: theme.cardBackground,
                                textColor: theme.primaryPurple,
                              ),
                              if (providerIndex == BigInt.zero)
                                TileButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/swap.svg",
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      theme.primaryPurple,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  disabled: false,
                                  onPressed: () {},
                                  backgroundColor: theme.cardBackground,
                                  textColor: theme.primaryPurple,
                                ),
                              TileButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/share.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    theme.primaryPurple,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                disabled: false,
                                onPressed: () async {
                                  await handleShare(context);
                                },
                                backgroundColor: theme.cardBackground,
                                textColor: theme.primaryPurple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _qrcodeGen(String addr, FTokenInfo token, NetworkConfigInfo provider) {
    if (token.providerIndex == BigInt.zero) {
      return CryptoQrGenerator.generateZilliqaQr(
        address: addr,
        amount: amount,
        token: token.addr,
      );
    } else if (token.providerIndex == BigInt.one) {
      return CryptoQrGenerator.generateEVMQr(
        chainId: provider.chainId.toInt(),
        amount: amount,
        token: token.addr,
        address: addr,
      );
    } else if (token.providerIndex == BigInt.two) {
      return CryptoQrGenerator.generateEVMQr(
        chainId: provider.chainId.toInt(),
        amount: amount,
        token: token.addr,
        address: addr,
        chainName: "binance",
      );
    } else {
      return "";
    }
  }
}
