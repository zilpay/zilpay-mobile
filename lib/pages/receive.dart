import 'package:blockies/blockies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zilpay/components/async_qrcode.dart';
import 'package:zilpay/components/custom_app_bar.dart';
import 'package:zilpay/components/image_cache.dart';
import 'package:zilpay/components/smart_input.dart';
import 'package:zilpay/components/tile_button.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/mixins/icon.dart';
import 'package:zilpay/mixins/qrcode.dart';
import 'package:zilpay/modals/select_token.dart';
import 'package:zilpay/src/rust/api/qrcode.dart';
import 'package:zilpay/src/rust/api/wallet.dart';
import 'package:zilpay/src/rust/models/ftoken.dart';
import 'package:zilpay/src/rust/models/provider.dart';
import 'package:zilpay/src/rust/models/qrcode.dart';
import 'package:zilpay/state/app_state.dart';
import 'package:zilpay/theme/app_theme.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  bool isCopied = false;
  bool isPressedToken = false;
  int selectedToken = 0;
  String amount = "0";
  Key _imageKey = UniqueKey();

  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);

    _amountController.text = amount;
    _accountNameController.text = appState.account?.name ?? "";
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> handleCopy(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    setState(() {
      isCopied = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    setState(() {
      isCopied = false;
    });
  }

  void handlePressedChanged(bool pressed) {
    setState(() {
      isPressedToken = pressed;
    });
  }

  void handleSelectToken() {
    showTokenSelectModal(
      context: context,
      onTokenSelected: (index) {
        setState(() {
          selectedToken = index;
          _imageKey = UniqueKey();
        });
      },
    );
  }

  Future<void> handleShare(
    FTokenInfo token,
    String addr,
    AppTheme theme,
    NetworkConfigInfo chain,
  ) async {
    QrConfigInfo config = QrConfigInfo(
      size: 600,
      gapless: false,
      color: theme.primaryPurple.toARGB32(),
      eyeShape: EyeShape.circle.value,
      dataModuleShape: DataModuleShape.circle.value,
    );
    String data = generateCryptoUrl(
      address: addr,
      chain: chain.shortName,
      token: token.addr,
      amount: amount,
    );

    try {
      final pngBytes = await genPngQrcode(data: data, config: config);
      final xFile = XFile.fromData(
        pngBytes,
        mimeType: 'image/png',
        name: 'qrcode.png',
      );
      await Share.shareXFiles(
        [xFile],
        text: '$addr, amount: $amount',
      );
    } catch (e) {
      debugPrint("error share: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);
    final chain = appState.chain!;
    final token = appState.wallet?.tokens[selectedToken];

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
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: adaptivePadding),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.warning.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          'Only send ${chain.name}(${token?.symbol}) assets to this address. Other assets will be lost forever.',
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
                                  width: double.infinity,
                                  padding: EdgeInsets.all(adaptivePadding),
                                  decoration: BoxDecoration(
                                    color: theme.cardBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildTokenSelector(theme, token),
                                      const SizedBox(height: 24),
                                      if (token != null &&
                                          appState.account != null)
                                        SizedBox(
                                          width: 220,
                                          height: 220,
                                          child: AsyncQRcode(
                                            data: generateCryptoUrl(
                                              address: appState.account!.addr,
                                              chain: chain.shortName,
                                              token: token.addr,
                                              amount: amount,
                                            ),
                                            color: theme.primaryPurple,
                                            size: 220,
                                            fit: BoxFit.contain,
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
                                const SizedBox(height: 16),
                                SmartInput(
                                  controller: _accountNameController,
                                  hint: 'Account name',
                                  onSubmitted: (_) async {
                                    if (_accountNameController
                                        .text.isNotEmpty) {
                                      await changeAccountName(
                                        walletIndex: BigInt.from(
                                            appState.selectedWallet),
                                        accountIndex:
                                            appState.wallet!.selectedAccount,
                                        newName: _accountNameController.text,
                                      );
                                      await appState.syncData();
                                    }
                                  },
                                  height: 50,
                                  rightIconPath: "assets/icons/edit.svg",
                                  borderColor: theme.cardBackground,
                                  focusedBorderColor: theme.primaryPurple,
                                  fontSize: 14,
                                ),
                                const SizedBox(height: 16),
                                _buildActionButtons(
                                  theme,
                                  chain,
                                  context,
                                ),
                              ],
                            ),
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

  Widget _buildTokenSelector(AppTheme theme, FTokenInfo? token) {
    final appState = Provider.of<AppState>(context);
    final chain = appState.chain!;

    return GestureDetector(
      onTapDown: (_) => handlePressedChanged(true),
      onTapUp: (_) => handlePressedChanged(false),
      onTapCancel: () => handlePressedChanged(false),
      onTap: handleSelectToken,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isPressedToken ? 0.6 : 1.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AsyncImage(
                  key: _imageKey,
                  url: viewTokenIcon(
                    token!,
                    chain.chainId,
                    theme.value,
                  ),
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorWidget: Blockies(
                    seed: token.addr,
                    color: theme.secondaryPurple,
                    bgColor: theme.primaryPurple,
                    spotColor: theme.background,
                    size: 8,
                  ),
                  loadingWidget: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              token.name,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              "(${token.symbol})",
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    AppTheme theme,
    NetworkConfigInfo chain,
    BuildContext context,
  ) {
    final appState = Provider.of<AppState>(context);
    final token = appState.wallet!.tokens[selectedToken];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TileButton(
          icon: SvgPicture.asset(
            isCopied ? "assets/icons/check.svg" : "assets/icons/copy.svg",
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
          onPressed: _handleAmountDialog,
          backgroundColor: theme.cardBackground,
          textColor: theme.primaryPurple,
        ),
        if (chain.chain == "ZIL") // TODO: only zil method
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
            onPressed: () {
              //TODO: if zilliqa we need change from bech32 to base16
            },
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
            await handleShare(
              token,
              appState.account?.addr ?? "",
              theme,
              chain,
            );
          },
          backgroundColor: theme.cardBackground,
          textColor: theme.primaryPurple,
        ),
      ],
    );
  }

  Future<void> _handleAmountDialog() async {
    _amountController.text = amount;

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<AppState>(context).currentTheme;

        return AlertDialog(
          backgroundColor: theme.cardBackground,
          title: Text(
            'Enter Amount',
            style: TextStyle(
              color: theme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\,\.]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  text: newValue.text.replaceAll(',', '.'),
                  selection: newValue.selection,
                );
              }),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) {
                  return newValue;
                }
                if (newValue.text.split('.').length > 2) {
                  return oldValue;
                }
                return newValue;
              }),
            ],
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: TextStyle(color: theme.textSecondary),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryPurple),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryPurple, width: 2),
              ),
            ),
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_amountController.text.isEmpty) {
                  _amountController.text = '0';
                }
                Navigator.pop(context, _amountController.text);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: theme.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        amount = result;
      });
    }
  }
}
