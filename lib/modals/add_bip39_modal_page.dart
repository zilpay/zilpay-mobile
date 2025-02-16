import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/components/counter.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/mixins/wallet_type.dart';
import 'package:zilpay/services/biometric_service.dart';
import 'package:zilpay/state/app_state.dart';
import '../../components/custom_app_bar.dart';
import '../../components/smart_input.dart';

class AddNextBip39AccountContent extends StatefulWidget {
  final VoidCallback onBack;

  const AddNextBip39AccountContent({
    super.key,
    required this.onBack,
  });

  @override
  State<AddNextBip39AccountContent> createState() =>
      _AddNextBip39AccountContentState();
}

class _AddNextBip39AccountContentState
    extends State<AddNextBip39AccountContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _passwordController = TextEditingController();
  late AppState _appState;

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscurePassphrase = true;
  String _errorMessage = '';

  final _nameInputKey = GlobalKey<SmartInputState>();
  final _passphraseInputKey = GlobalKey<SmartInputState>();
  final _passwordInputKey = GlobalKey<SmartInputState>();

  @override
  void dispose() {
    _nameController.dispose();
    _passphraseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
    _nameController.text = 'Account ${_appState.wallet!.accounts.length + 1}';
  }

  bool _validateForm() {
    setState(() => _errorMessage = '');
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      _nameInputKey.currentState?.shake();
      setState(() => _errorMessage = 'Please enter account name');
      return false;
    }

    final bool isPhr = _appState.wallet!.walletType.split(".").last == "true";
    final bool needsPassphrase =
        _appState.wallet!.walletType.contains(WalletType.SecretPhrase.name) &&
            isPhr;

    if (needsPassphrase) {
      if (_passphraseController.text.trim().isEmpty) {
        _passphraseInputKey.currentState?.shake();
        setState(() => _errorMessage = 'Please enter passphrase');
        return false;
      }
    }

    final bool needsPassword =
        _appState.wallet!.authType == AuthMethod.none.name &&
            !_appState.wallet!.walletType.contains(WalletType.ledger.name);

    if (needsPassword) {
      if (_passwordController.text.isEmpty) {
        _passwordInputKey.currentState?.shake();
        setState(() => _errorMessage = 'Please enter password');
        return false;
      }
    }

    return isValid;
  }

  Future<void> _onSubmit() async {
    if (_validateForm()) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).currentTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    const inputHeight = 50.0;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);

    final bool isPhr = _appState.wallet!.walletType.split(".").last == "true";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppBar(
          title: '',
          onBackPressed: _loading ? () {} : widget.onBack,
          actionIcon: _loading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.textPrimary),
                  ),
                )
              : SvgPicture.asset(
                  'assets/icons/plus.svg',
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    theme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
          onActionPressed: _loading ? () {} : _onSubmit,
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 0,
              bottom: bottomInset > 0 ? bottomInset + 40.0 : 40.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SmartInput(
                    key: _nameInputKey,
                    controller: _nameController,
                    hint: "Enter account name",
                    height: inputHeight,
                    fontSize: 18,
                    focusedBorderColor: theme.primaryPurple,
                    padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
                    disabled: _loading,
                    onChanged: (value) => setState(() => _errorMessage = ''),
                  ),
                  SizedBox(height: adaptivePadding),
                  Counter(
                    iconSize: 32,
                    iconColor: theme.textPrimary,
                    minValue: 1,
                    maxValue: 255,
                    animationDuration: const Duration(milliseconds: 300),
                    numberStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                    initialValue: _appState.wallet!.accounts.length + 1,
                    disabled: _loading,
                    onChanged: !_loading
                        ? (value) {
                            setState(() {
                              _nameController.text = 'Account $value';
                            });
                          }
                        : null,
                  ),
                  if (_appState.wallet!.walletType
                          .contains(WalletType.SecretPhrase.name) &&
                      isPhr) ...[
                    SizedBox(height: adaptivePadding),
                    SmartInput(
                      key: _passphraseInputKey,
                      controller: _passphraseController,
                      hint: "Enter passphrase",
                      height: inputHeight,
                      fontSize: 18,
                      obscureText: _obscurePassphrase,
                      focusedBorderColor: theme.primaryPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      disabled: _loading,
                      rightIconPath: _obscurePassphrase
                          ? "assets/icons/close_eye.svg"
                          : "assets/icons/open_eye.svg",
                      onRightIconTap: _loading
                          ? null
                          : () => setState(
                              () => _obscurePassphrase = !_obscurePassphrase),
                      onChanged: (value) => setState(() => _errorMessage = ''),
                    ),
                  ],
                  if (_appState.wallet!.authType == AuthMethod.none.name &&
                      !_appState.wallet!.walletType
                          .contains(WalletType.ledger.name)) ...[
                    SizedBox(height: adaptivePadding),
                    SmartInput(
                      key: _passwordInputKey,
                      controller: _passwordController,
                      hint: "Enter password",
                      height: inputHeight,
                      fontSize: 18,
                      obscureText: _obscurePassword,
                      focusedBorderColor: theme.primaryPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      disabled: _loading,
                      rightIconPath: _obscurePassword
                          ? "assets/icons/close_eye.svg"
                          : "assets/icons/open_eye.svg",
                      onRightIconTap: _loading
                          ? null
                          : () => setState(
                              () => _obscurePassword = !_obscurePassword),
                      onChanged: (value) => setState(() => _errorMessage = ''),
                    ),
                  ],
                  if (_errorMessage.isNotEmpty) ...[
                    SizedBox(height: adaptivePadding),
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: theme.danger,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
