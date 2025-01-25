import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:zilpay/state/app_state.dart';

class MnemonicWordInput extends StatefulWidget {
  final int index;
  final String word;
  final bool isEditable;
  final Color? borderColor;
  final Color? errorBorderColor;
  final bool hasError;
  final double opacity;
  final Function(int, String)? onChanged;

  const MnemonicWordInput({
    super.key,
    required this.index,
    required this.word,
    this.onChanged,
    this.opacity = 1,
    this.isEditable = false,
    this.borderColor,
    this.errorBorderColor,
    this.hasError = false,
  });

  @override
  State<MnemonicWordInput> createState() => _MnemonicWordInputState();
}

class _MnemonicWordInputState extends State<MnemonicWordInput> {
  late TextEditingController _controller;
  bool _shouldUpdateText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.word);
  }

  @override
  void didUpdateWidget(MnemonicWordInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdateText && widget.word != _controller.text) {
      _controller.text = widget.word;
    }
    _shouldUpdateText = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).currentTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardBackground.withValues(alpha: widget.opacity),
        borderRadius: BorderRadius.circular(16),
        border: widget.hasError
            ? Border.all(
                color: widget.errorBorderColor ?? theme.danger,
                width: 1,
              )
            : widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1)
                : null,
      ),
      child: Row(
        children: [
          Text(
            '${widget.index}',
            style: TextStyle(
              color: widget.hasError
                  ? (widget.errorBorderColor ?? theme.danger)
                  : theme.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: widget.hasError
                    ? (widget.errorBorderColor ?? theme.danger)
                    : theme.textPrimary,
              ),
              enabled: widget.isEditable,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                _shouldUpdateText = false;
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.index, value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
