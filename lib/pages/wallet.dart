import 'package:blockies/blockies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/components/smart_input.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/components/custom_app_bar.dart';
import 'package:zilpay/components/biometric_switch.dart';
import 'package:zilpay/mixins/wallet_type.dart';
import 'package:zilpay/modals/confirm_password.dart';
import 'package:zilpay/modals/delete_wallet.dart';
import 'package:zilpay/modals/manage_connections.dart';
import 'package:zilpay/modals/secret_recovery_modal.dart';
import 'package:zilpay/services/auth_guard.dart';
import 'package:zilpay/services/biometric_service.dart';
import 'package:zilpay/services/device.dart';
import 'package:zilpay/src/rust/api/connections.dart';
import 'package:zilpay/src/rust/api/wallet.dart';
import 'package:zilpay/state/app_state.dart';
import '../theme/app_theme.dart';
import 'package:zilpay/l10n/app_localizations.dart';

class WalletPreferenceItem {
  final String title;
  final String iconPath;
  final bool hasSwitch;
  final bool switchValue;
  final bool switchEnabled;
  final Function(bool)? onChanged;
  final VoidCallback? onTap;

  WalletPreferenceItem({
    required this.title,
    required this.iconPath,
    this.hasSwitch = false,
    this.switchValue = false,
    this.switchEnabled = true,
    this.onChanged,
    this.onTap,
  });
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late final AuthGuard _authGuard;
  final AuthService _authService = AuthService();
  final TextEditingController _walletNameController = TextEditingController();
  static const double _avatarSize = 80.0;
  static const double _borderRadius = 12.0;
  static const double _iconSize = 24.0;
  static const double _fontSize = 16.0;

  List<AuthMethod> _authMethods = [AuthMethod.none];
  bool _biometricsAvailable = false;
  bool _isBiometricLoading = false;

  @override
  void initState() {
    super.initState();
    _authGuard = Provider.of<AuthGuard>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    _walletNameController.text = appState.wallet!.walletName;
    appState.syncConnections();
    _checkAuthMethods();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthMethods() async {
    try {
      final methods = await _authService.getAvailableAuthMethods();

      setState(() {
        _authMethods = methods;
        _biometricsAvailable =
            methods.isNotEmpty && methods.first != AuthMethod.none;
      });
    } catch (e) {
      debugPrint("Error checking auth methods: $e");
      setState(() {
        _authMethods = [AuthMethod.none];
        _biometricsAvailable = false;
      });
    }
  }

  void _handleDappDisconnect(String url) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    await removeConnections(
      walletIndex: BigInt.from(appState.selectedWallet),
      domain: url,
    );
    await appState.syncConnections();
  }

  Future<void> _handleToggleBiometric(bool enable, AppState appState) async {
    if (_isBiometricLoading) return;

    setState(() {
      _isBiometricLoading = true;
    });

    try {
      final wallet = appState.wallet;
      if (wallet == null) {
        setState(() {
          _isBiometricLoading = false;
        });
        return;
      }

      final device = DeviceInfoService();
      final identifiers = await device.getDeviceIdentifiers();

      if (enable && mounted) {
        showConfirmPasswordModal(
          context: context,
          theme: appState.currentTheme,
          onDismiss: () {
            if (mounted) {
              setState(() {
                _isBiometricLoading = false;
              });
            }
          },
          onConfirm: (password) async {
            try {
              final authenticated = await _authService.authenticate(
                allowPinCode: true,
                reason: AppLocalizations.of(context)!.walletPageBiometricReason,
              );

              if (!authenticated) {
                return false;
              }

              final biometricType = _authMethods.first.name;

              final session = await setBiometric(
                walletIndex: BigInt.from(appState.selectedWallet),
                identifiers: identifiers,
                password: password,
                newBiometricType: biometricType,
              );

              if (session != null) {
                await _authGuard.setSession(wallet.walletAddress, session);
              }

              await appState.syncData();

              if (mounted) {
                setState(() {
                  _isBiometricLoading = false;
                });
              }

              return true;
            } catch (e) {
              return false;
            }
          },
        );
      } else {
        String sessionCipher = "";

        try {
          sessionCipher = await _authGuard.getSession(
            sessionKey: wallet.walletAddress,
            requireAuth: false,
          );
        } catch (e) {
          debugPrint("No session available for disabling biometrics: $e");
        }

        await setBiometric(
          walletIndex: BigInt.from(appState.selectedWallet),
          identifiers: identifiers,
          password: "",
          sessionCipher: sessionCipher,
          newBiometricType: AuthMethod.none.name,
        );
        await _authGuard.setSession(wallet.walletAddress, "");

        if (mounted) {
          setState(() {
            _isBiometricLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error changing biometric: $e");
      if (mounted) {
        setState(() {
          _isBiometricLoading = false;
        });
      }
    } finally {
      await appState.syncData();
    }
  }

  List<WalletPreferenceItem> _getPreferenceItems(AppState appState) {
    final l10n = AppLocalizations.of(context)!;
    final List<WalletPreferenceItem> items = [];

    items.add(
      WalletPreferenceItem(
        title: l10n.walletPageManageConnections,
        iconPath: 'assets/icons/globe.svg',
        onTap: () {
          if (appState.connections.isNotEmpty) {
            showConnectedDappsModal(
              context: context,
              onDappDisconnect: _handleDappDisconnect,
            );
          }
        },
      ),
    );

    if (!appState.wallet!.walletType.contains(WalletType.ledger.name)) {
      items.add(
        WalletPreferenceItem(
          title: l10n.walletPageBackup,
          iconPath: 'assets/icons/key.svg',
          onTap: () {
            if (!appState.wallet!.walletType.contains(WalletType.ledger.name)) {
              _handleBackup(appState.currentTheme);
            }
          },
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CustomAppBar(
                    title: l10n.walletPageTitle,
                    onBackPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: adaptivePadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(child: _buildWalletHeader(theme, appState)),
                      const SizedBox(height: 16),
                      _buildWalletNameInput(theme, appState),
                      const SizedBox(height: 32),
                      _buildPreferencesSection(appState),
                    ]),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: adaptivePadding,
                      right: adaptivePadding,
                      bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildRemoveWalletButton(appState),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildWalletHeader(AppTheme theme, AppState appState) {
    return SizedBox(
      width: _avatarSize,
      height: _avatarSize,
      child: Container(
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(_avatarSize / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_avatarSize / 2),
          child: Transform.scale(
            scale: 1.0,
            child: Blockies(
              seed: appState.account!.addr,
              color: theme.secondaryPurple,
              bgColor: theme.primaryPurple,
              spotColor: theme.background,
              size: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletNameInput(AppTheme theme, AppState state) {
    return SmartInput(
      controller: _walletNameController,
      hint: AppLocalizations.of(context)!.walletPageWalletNameHint,
      onSubmitted: (_) async {
        if (_walletNameController.text.isNotEmpty) {
          await changeWalletName(
            walletIndex: BigInt.from(state.selectedWallet),
            newName: _walletNameController.text,
          );
          await state.syncData();
        }
      },
      height: 50,
      rightIconPath: "assets/icons/edit.svg",
      borderColor: theme.cardBackground,
      focusedBorderColor: theme.primaryPurple,
      fontSize: _fontSize,
    );
  }

  Widget _buildPreferencesSection(AppState appState) {
    final theme = appState.currentTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            AppLocalizations.of(context)!.walletPagePreferencesTitle,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: _fontSize,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Column(
            children: _buildPreferenceItems(appState),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPreferenceItems(AppState appState) {
    final theme = appState.currentTheme;
    final items = _getPreferenceItems(appState);
    final List<Widget> widgets = [];

    if (_biometricsAvailable && _authMethods.first != AuthMethod.none) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: BiometricSwitch(
            biometricType: _authMethods.first,
            value: AuthMethod.none.name != appState.wallet?.authType,
            disabled: false,
            isLoading: _isBiometricLoading,
            onChanged: (value) => _handleToggleBiometric(value, appState),
          ),
        ),
      );

      if (items.isNotEmpty) {
        widgets.add(Divider(
          height: 1,
          color: theme.textSecondary.withValues(alpha: 0.1),
        ));
      }
    }

    for (var i = 0; i < items.length; i++) {
      widgets.add(_buildPreferenceItem(theme, items[i], appState));
      if (i < items.length - 1) {
        widgets.add(Divider(
          height: 1,
          color: theme.textSecondary.withValues(alpha: 0.1),
        ));
      }
    }

    return widgets;
  }

  Widget _buildPreferenceItem(
      AppTheme theme, WalletPreferenceItem item, AppState appState) {
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              item.iconPath,
              width: _iconSize,
              height: _iconSize,
              colorFilter: ColorFilter.mode(
                theme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: _fontSize,
                ),
              ),
            ),
            if (item.hasSwitch)
              Switch(
                value: item.switchValue,
                onChanged: item.switchEnabled ? item.onChanged : null,
                activeColor: theme.primaryPurple,
              )
            else if (item.title ==
                AppLocalizations.of(context)!.walletPageManageConnections)
              Text(
                '${appState.connections.length}',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: _fontSize,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveWalletButton(AppState appState) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        showDeleteWalletModal(context: context, state: appState);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.walletPageDeleteWallet,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: _fontSize,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/logout.svg',
              colorFilter: const ColorFilter.mode(
                Colors.red,
                BlendMode.srcIn,
              ),
              width: _iconSize,
              height: _iconSize,
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackup(AppTheme theme) {
    showSecretRecoveryModal(context: context, theme: theme);
  }
}
