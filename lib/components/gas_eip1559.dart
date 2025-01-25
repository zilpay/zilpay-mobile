import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/mixins/gas_eip1559.dart';
import 'package:zilpay/src/rust/models/ftoken.dart';
import 'package:zilpay/src/rust/models/gas.dart';
import 'package:zilpay/src/rust/models/provider.dart';
import 'package:zilpay/state/app_state.dart';

extension GasFeeOptionX on GasFeeOption {
  String get title {
    switch (this) {
      case GasFeeOption.low:
        return 'Low';
      case GasFeeOption.market:
        return 'Market';
      case GasFeeOption.aggressive:
        return 'Aggressive';
    }
  }

  String get icon {
    switch (this) {
      case GasFeeOption.low:
        return '🐢';
      case GasFeeOption.market:
        return '🐉';
      case GasFeeOption.aggressive:
        return '👹';
    }
  }

  String get description {
    switch (this) {
      case GasFeeOption.low:
        return 'Slower but cheaper';
      case GasFeeOption.market:
        return 'Recommended';
      case GasFeeOption.aggressive:
        return 'Faster but expensive';
    }
  }

  String get confirmationTime {
    switch (this) {
      case GasFeeOption.low:
        return '~3-5 min';
      case GasFeeOption.market:
        return '~30-60 sec';
      case GasFeeOption.aggressive:
        return '~10-15 sec';
    }
  }
}

class GasEIP1559 extends StatefulWidget {
  final GasInfo gasInfo;
  final Function(GasFeeOption type) onSelect;
  final GasFeeOption selected;

  const GasEIP1559({
    super.key,
    required this.gasInfo,
    required this.onSelect,
    this.selected = GasFeeOption.market,
  });

  @override
  State<GasEIP1559> createState() => _GasEIP1559State();
}

class _GasEIP1559State extends State<GasEIP1559>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;
  late GasFeeOption _lastSelected;

  @override
  void initState() {
    super.initState();
    _lastSelected = widget.selected;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _validateFees();
  }

  void _validateFees() {
    assert(
        widget.gasInfo.feeHistory.maxFee >= widget.gasInfo.feeHistory.baseFee,
        'Max fee must be greater than base fee');
    assert(
        widget.gasInfo.feeHistory.maxFee >=
            widget.gasInfo.feeHistory.priorityFee,
        'Max fee must be greater than priority fee');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGasOption({
    required GasFeeOption option,
    required Color textColor,
    required AppState appState,
    required NetworkConfigInfo chain,
    required FTokenInfo token,
  }) {
    final theme = appState.currentTheme;
    final isSelected = widget.selected == option;

    final maxFeePerGas = calculateFeeForOption(
      option,
      widget.gasInfo.feeHistory.baseFee,
      widget.gasInfo.feeHistory.priorityFee,
    );

    final totalGasFee = calculateTotalGasCost(
      option,
      widget.gasInfo.feeHistory.baseFee,
      widget.gasInfo.feeHistory.priorityFee,
      widget.gasInfo.txEstimateGas,
    );

    return GestureDetector(
      onTap: () {
        if (widget.selected == option) {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        } else {
          _lastSelected = option;
          widget.onSelect(option);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(option.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.confirmationTime,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatGasPrice(totalGasFee, token.decimals, token.symbol),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected && _isExpanded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Fee:',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          formatGasPriceDetail(
                              widget.gasInfo.feeHistory.baseFee),
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Priority Fee:',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          formatGasPriceDetail(
                            calculateMaxPriorityFee(
                              option,
                              widget.gasInfo.feeHistory.priorityFee,
                            ),
                          ),
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Max Fee:',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          formatGasPriceDetail(maxFeePerGas),
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final selectedOption = _isExpanded ? widget.selected : _lastSelected;
    final chain = appState.chain!;
    final token = appState.wallet!.tokens.first;

    return Column(
      children: [
        if (_isExpanded || selectedOption == GasFeeOption.low)
          _buildGasOption(
            option: GasFeeOption.low,
            textColor: theme.warning,
            appState: appState,
            chain: chain,
            token: token,
          ),
        if (_isExpanded || selectedOption == GasFeeOption.market)
          _buildGasOption(
            option: GasFeeOption.market,
            textColor: theme.success,
            appState: appState,
            chain: chain,
            token: token,
          ),
        if (_isExpanded || selectedOption == GasFeeOption.aggressive)
          _buildGasOption(
            option: GasFeeOption.aggressive,
            textColor: theme.danger,
            appState: appState,
            chain: chain,
            token: token,
          ),
      ],
    );
  }
}
