import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:zilpay/components/button.dart';
import 'package:zilpay/components/custom_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:zilpay/components/option_list.dart';
import 'package:zilpay/config/argon.dart';
import 'package:zilpay/mixins/adaptive_size.dart';
import 'package:zilpay/modals/argon2.dart';
import 'package:zilpay/src/rust/models/keypair.dart';
import 'package:zilpay/src/rust/models/provider.dart';
import 'package:zilpay/src/rust/models/settings.dart';
import 'package:zilpay/state/app_state.dart';

class CipherSettingsPage extends StatefulWidget {
  const CipherSettingsPage({
    super.key,
  });

  @override
  State<CipherSettingsPage> createState() => _CipherSettingsPageState();
}

class _CipherSettingsPageState extends State<CipherSettingsPage> {
  List<String>? _bip39List;
  NetworkConfigInfo? _chain;
  KeyPairInfo? _keys;
  bool _zilLegacy = false;
  WalletArgonParamsInfo _argonParams = Argon2DefaultParams.owaspDefault();

  int selectedCipherIndex = 2;
  bool optionsDisabled = false;

  final List<Map<String, String>> cipherDescriptions = [
    {
      'title': 'Standard Encryption',
      'subtitle': 'AES-256',
      'description':
          'Basic level encryption suitable for most users. Uses AES-256 algorithm - current industry standard.',
    },
    {
      'title': 'Enhanced Security',
      'subtitle': 'AES-256 + TwoFish',
      'description':
          'Recommended. Double layer encryption using AES-256 and TwoFish for enhanced security.',
    },
    {
      'title': 'Post-Quantum Protection',
      'subtitle': 'AES-256 + NTRU-Prime',
      'description':
          'Highest security level with quantum resistance. Combines AES-256 with NTRU-Prime algorithm.',
    },
  ];

  void _onAdvancedPressed() {
    showArgonSettingsModal(
      context: context,
      onParamsSelected: (WalletArgonParamsInfo params) {
        setState(() {
          _argonParams = params;
        });
      },
      argonParams: _argonParams,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    setState(() {
      optionsDisabled = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bip39 = args?['bip39'] as List<String>?;
    final chain = args?['chain'] as NetworkConfigInfo?;
    final keys = args?['keys'] as KeyPairInfo?;
    final zilLegacy = args?['zilLegacy'] as bool?;

    if (bip39 == null && chain == null && keys == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/initial');
      });
    } else {
      setState(() {
        _bip39List = bip39;
        _chain = chain;
        _keys = keys;
        _zilLegacy = zilLegacy ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).currentTheme;
    final adaptivePadding = AdaptiveSize.getAdaptivePadding(context, 16);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Setup Encryption',
                  onBackPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: adaptivePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _onAdvancedPressed,
                                  style: ButtonStyle(
                                    overlayColor:
                                        const WidgetStatePropertyAll<Color>(
                                            Colors.transparent),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return theme.primaryPurple
                                              .withValues(alpha: 0.7);
                                        }
                                        return theme.primaryPurple;
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    'Advanced',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OptionsList(
                            disabled: optionsDisabled,
                            options: List.generate(
                              cipherDescriptions.length,
                              (index) => OptionItem(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cipherDescriptions[index]['title']!,
                                      style: TextStyle(
                                        color: theme.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cipherDescriptions[index]['subtitle']!,
                                      style: TextStyle(
                                        color: theme.primaryPurple,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cipherDescriptions[index]['description']!,
                                      style: TextStyle(
                                        color: theme.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                isSelected: selectedCipherIndex == index,
                                onSelect: () =>
                                    setState(() => selectedCipherIndex = index),
                              ),
                            ),
                            unselectedOpacity: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(adaptivePadding),
                  child: Column(
                    children: [
                      if (selectedCipherIndex == 2)
                        Padding(
                          padding: EdgeInsets.only(bottom: adaptivePadding),
                          child: Text(
                            'Post-quantum encryption might affect performance',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CustomButton(
                        textColor: theme.buttonText,
                        backgroundColor: theme.primaryPurple,
                        text: 'Confirm',
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/pass_setup',
                            arguments: {
                              'bip39': _bip39List,
                              'chain': _chain,
                              'keys': _keys,
                              'cipher': _getCipherOrders(),
                              'argon2': _argonParams,
                              'zilLegacy': _zilLegacy,
                            },
                          );
                        },
                        borderRadius: 30.0,
                        height: 50.0,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Uint8List _getCipherOrders() {
    // TODO: TwoFish is not supporting yet
    //
    switch (selectedCipherIndex) {
      case 0:
        return Uint8List.fromList([0]); // AESGCM256 only
      case 1:
        return Uint8List.fromList(
            [0, 1]); // AESGCM256 + TwoFish // TODO: is not supporte yet
      case 2:
        return Uint8List.fromList([0, 1]); // AESGCM256 + TwoFish + NTRUP1277
      default:
        return Uint8List.fromList([0, 1]); // AESGCM256 + TwoFish + NTRUP1277
    }
  }
}
