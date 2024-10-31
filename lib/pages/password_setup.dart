import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zilpay/components/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/components/gradient_bg.dart';
import 'package:zilpay/components/load_button.dart';
import 'package:zilpay/components/smart_input.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/services/biometric_service.dart';
import 'package:zilpay/theme/app_theme.dart';
import '../theme/theme_provider.dart';

class PasswordSetupPage extends StatefulWidget {
  const PasswordSetupPage({super.key});

  @override
  State<PasswordSetupPage> createState() => _PasswordSetupPageState();
}

class _PasswordSetupPageState extends State<PasswordSetupPage> {
  final AuthService _authService = AuthService();
  List<AuthMethod> _authMethods = [AuthMethod.none];
  bool _useDeviceAuth = false;

  String _errorMessage = '';

  final _btnController = RoundedLoadingButtonController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordInputKey = GlobalKey<SmartInputState>();
  final _confirmPasswordInputKey = GlobalKey<SmartInputState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _checkAuthMethods();
  }

  @override
  void dispose() {
    _checkAuthMethods();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  bool _validatePasswords() {
    if (_passwordController.text.length < 8) {
      _passwordInputKey.currentState?.shake();

      setState(() {
        _errorMessage = 'Password must be at least 8 characters';
      });

      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _confirmPasswordInputKey.currentState?.shake();

      setState(() {
        _errorMessage = 'Passwords do not match';
      });

      return false;
    }

    return true;
  }

  void _createWallet() async {
    setState(() {
      _errorMessage = '';
    });

    if (!_validatePasswords()) {
      _btnController.reset();
      return;
    }

    try {
      if (_useDeviceAuth) {
        final authenticated = await _authService.authenticate(
          allowPinCode: _authMethods.contains(AuthMethod.pinCode),
          reason: 'Please authenticate to enable quick access',
        );

        setState(() => _useDeviceAuth = authenticated);

        if (!authenticated) {
          return;
        }
      }

      _btnController.start();

      Timer(const Duration(seconds: 5), () {
        _btnController.success();
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      _btnController.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
            child: Column(
              children: [
                CustomAppBar(
                  title: '',
                  onBackPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Password',
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your password must be at least 8 characters',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SmartInput(
                            key: _passwordInputKey,
                            controller: _passwordController,
                            hint: "Password",
                            fontSize: 18,
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            focusedBorderColor: theme.primaryPurple,
                            obscureText: _obscurePassword,
                            rightIconPath: _obscurePassword
                                ? "assets/icons/close_eye.svg"
                                : "assets/icons/open_eye.svg",
                            onChanged: (value) {
                              if (_errorMessage != '') {
                                setState(() {
                                  _errorMessage = '';
                                });
                              }
                            },
                            onRightIconTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SmartInput(
                            key: _confirmPasswordInputKey,
                            controller: _confirmPasswordController,
                            hint: "Confirm Password",
                            height: 56,
                            fontSize: 18,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            obscureText: _obscureConfirmPassword,
                            rightIconPath: _obscureConfirmPassword
                                ? "assets/icons/close_eye.svg"
                                : "assets/icons/open_eye.svg",
                            onRightIconTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            onChanged: (value) {
                              if (_errorMessage != '') {
                                setState(() {
                                  _errorMessage = '';
                                });
                              }
                            },
                            onSubmitted: _createWallet,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage,
                            style: TextStyle(
                              color: theme.danger,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _buildAuthOption(theme),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: adaptivePadding,
                      left: adaptivePadding,
                      right: adaptivePadding),
                  child: RoundedLoadingButton(
                    controller: _btnController,
                    onPressed: _createWallet,
                    successIcon: SvgPicture.asset(
                      'assets/icons/ok.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        theme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    child: Text(
                      'Create Password',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  Widget _buildAuthOption(AppTheme theme) {
    if (_authMethods.contains(AuthMethod.none)) {
      return const SizedBox.shrink();
    }

    final authText = _getAuthMethodText();
    final iconPath = _getAuthMethodIcon();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                authText,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Switch(
            value: _useDeviceAuth,
            onChanged: (value) async {
              setState(() => _useDeviceAuth = value);
            },
            activeColor: theme.primaryPurple,
            activeTrackColor: theme.primaryPurple.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  String _getAuthMethodText() {
    if (_authMethods.contains(AuthMethod.faceId)) {
      return 'Enable Face ID';
    } else if (_authMethods.contains(AuthMethod.fingerprint)) {
      return 'Enable Fingerprint';
    } else if (_authMethods.contains(AuthMethod.biometric)) {
      return 'Enable Biometric Login';
    } else if (_authMethods.contains(AuthMethod.pinCode)) {
      return 'Enable Device PIN';
    }
    return '';
  }

  String _getAuthMethodIcon() {
    if (_authMethods.contains(AuthMethod.faceId)) {
      return 'assets/icons/face_id.svg';
    } else if (_authMethods.contains(AuthMethod.fingerprint)) {
      return 'assets/icons/fingerprint.svg';
    } else if (_authMethods.contains(AuthMethod.biometric)) {
      return 'assets/icons/biometric.svg';
    } else if (_authMethods.contains(AuthMethod.pinCode)) {
      return 'assets/icons/pin.svg';
    }
    return '';
  }

  Future<void> _checkAuthMethods() async {
    final methods = await _authService.getAvailableAuthMethods();
    setState(() {
      _authMethods = methods;
    });
  }
}
