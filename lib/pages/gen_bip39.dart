import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zilpay/components/mnemonic_word_input.dart';
import 'package:zilpay/components/wor_count_selector.dart';
import 'package:zilpay/src/rust/api/simple.dart';
import '../theme/theme_provider.dart';
import '../components/gradient_bg.dart';

class SecretPhraseGeneratorPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<SecretPhraseGeneratorPage> {
  List<String> _mnemonicWords = [];
  var _count = 12;
  bool _hasBackupWords = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _regenerateMnemonicWords();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/back.svg',
                        width: 24,
                        height: 24,
                        color: theme.secondaryPurple,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/reload.svg',
                        width: 30,
                        height: 30,
                        color: theme.textPrimary,
                      ),
                      onPressed: _regenerateMnemonicWords,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      WordCountSelector(
                        wordCounts: const [12, 15, 18, 21, 24],
                        selectedCount: _count,
                        onCountChanged: (newCount) {
                          setState(() {
                            _count = newCount;
                            _regenerateMnemonicWords();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              items: ['English', 'Spanish'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          TextStyle(color: theme.textPrimary)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLanguage = newValue!;
                                });
                              },
                              dropdownColor: theme.cardBackground,
                              style: TextStyle(color: theme.textPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _mnemonicWords.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MnemonicWordInput(
                                index: index + 1,
                                word: _mnemonicWords[index],
                                isEditable: false,
                                borderColor: theme.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(
                          'I have backup words',
                          style: TextStyle(color: theme.textSecondary),
                        ),
                        value: _hasBackupWords,
                        onChanged: (newValue) {
                          setState(() {
                            _hasBackupWords = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: theme.primaryPurple,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Next'),
                        onPressed: _hasBackupWords
                            ? () {
                                // Implement next step functionality
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          // primary: theme.primaryPurple,
                          // onPrimary: theme.buttonText,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _regenerateMnemonicWords() async {
    String words = await genBip39Words(count: _count);

    setState(() {
      _mnemonicWords = words.split(" ");
    });
  }
}
