import 'dart:math';

import 'package:blockies/blockies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/components/button.dart';
import 'package:zilpay/components/image_cache.dart';
import 'package:zilpay/l10n/app_localizations.dart';
import 'package:zilpay/mixins/amount.dart';
import 'package:zilpay/mixins/preprocess_url.dart';
import 'package:zilpay/modals/stake_modal.dart';
import 'package:zilpay/modals/transfer.dart';
import 'package:zilpay/src/rust/api/stake.dart';
import 'package:zilpay/src/rust/api/wallet.dart';
import 'package:zilpay/src/rust/models/stake.dart';
import 'package:zilpay/src/rust/models/transactions/request.dart';
import 'package:zilpay/state/app_state.dart';
import 'package:zilpay/theme/app_theme.dart';

class StakingPoolCard extends StatelessWidget {
  final FinalOutputInfo stake;

  const StakingPoolCard({super.key, required this.stake});

  bool get isLiquidStaking => stake.token != null;
  bool get isScilla => stake.tag == "scilla";
  bool get isEVM => stake.tag == 'evm';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.currentTheme;
    final l10n = AppLocalizations.of(context)!;
    final hasRewards =
        (BigInt.tryParse(stake.rewards) ?? BigInt.zero) > BigInt.zero;
    final hasDelegation =
        (BigInt.tryParse(stake.delegAmt) ?? BigInt.zero) > BigInt.zero;
    final hasClaimAmount =
        (BigInt.tryParse(stake.claimableAmount) ?? BigInt.zero) > BigInt.zero;
    final showStakingInfo = hasRewards || hasDelegation || hasClaimAmount;
    final hasPendingWithdrawals = stake.pendingWithdrawals.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.textSecondary.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildCardHeader(theme, l10n),
                if (hasPendingWithdrawals) ...[
                  const SizedBox(height: 20),
                  _buildPendingWithdrawals(context, theme, l10n, appState),
                ],
                if (showStakingInfo) ...[
                  const SizedBox(height: 20),
                  _buildUserStakingInfo(context, theme, l10n, appState),
                  const SizedBox(height: 16),
                  _buildStatsRow(theme, l10n, appState),
                  if (isLiquidStaking) ...[
                    const SizedBox(height: 16),
                    _buildLiquidStakingInfo(theme, l10n, appState),
                  ],
                  if (hasRewards) ...[
                    const SizedBox(height: 16),
                    _buildClaimRewardsButton(context, theme, l10n, appState),
                  ],
                ] else ...[
                  const SizedBox(height: 16),
                  _buildStatsRow(theme, l10n, appState),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.textSecondary.withValues(alpha: 0.08),
                ),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: _buildActionButtons(context, appState, l10n, hasDelegation),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(AppTheme theme, AppLocalizations l10n) {
    String urlTemplate =
        "https://raw.githubusercontent.com/zilpay/zilpay-cdn/refs/heads/main/stakeing/zilliqa/icons/%{address}%/%{dark,light}%.webp";
    final replacements = <String, String>{
      'address': stake.address.toLowerCase(),
    };

    return Row(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: AsyncImage(
                url: processUrlTemplate(
                  template: urlTemplate,
                  theme: theme.value,
                  replacements: replacements,
                ),
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                loadingWidget: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CupertinoActivityIndicator(radius: 12.0),
                  ),
                ),
                errorWidget: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/zil.svg',
                    width: 28,
                    height: 28,
                    colorFilter:
                        ColorFilter.mode(theme.warning, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.textSecondary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset(
                  isScilla
                      ? 'assets/icons/scilla.svg'
                      : 'assets/icons/solidity.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    theme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stake.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isScilla
                          ? theme.success.withValues(alpha: 0.1)
                          : theme.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stake.tag.toUpperCase(),
                      style: TextStyle(
                        color: theme.primaryPurple,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (isLiquidStaking) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LP',
                        style: TextStyle(
                          color: theme.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingWithdrawals(
    BuildContext context,
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.warning.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/icons/clock.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(theme.warning, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.pendingWithdrawals,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${stake.pendingWithdrawals.length}',
                  style: TextStyle(
                    color: theme.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stake.pendingWithdrawals.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                      bottom: entry.key < stake.pendingWithdrawals.length - 1
                          ? 12
                          : 0),
                  child: _buildPendingWithdrawalItem(
                      context, theme, l10n, appState, entry.value),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildPendingWithdrawalItem(
    BuildContext context,
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
    PendingWithdrawalInfo item,
  ) {
    final currentBlock = stake.currentBlock ?? BigInt.zero;
    final withdrawalBlock = item.withdrawalBlock;
    final blocksRemaining = withdrawalBlock > currentBlock
        ? withdrawalBlock - currentBlock
        : BigInt.zero;

    final isClaimable = item.claimable || blocksRemaining == BigInt.zero;
    final progress = blocksRemaining == BigInt.zero
        ? 1.0
        : withdrawalBlock > currentBlock
            ? 0.0
            : 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isClaimable
              ? theme.success.withValues(alpha: 0.2)
              : theme.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.amount,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTokenAmount(item.amount, appState).$1,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isClaimable) ...[
                CustomButton(
                  text: l10n.claimButton,
                  onPressed: () => _claimWithdrawal(context, appState, item),
                  backgroundColor: theme.success,
                  textColor: theme.buttonText,
                  height: 36,
                  width: 80,
                  borderRadius: 12,
                ),
              ],
            ],
          ),
          if (!isClaimable && blocksRemaining > BigInt.zero) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${l10n.claimableIn} ${_formatTime(blocksRemaining)}',
                  style: TextStyle(
                    color: theme.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.textSecondary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.warning),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(BigInt blocks) {
    final seconds = (blocks.toDouble() * 1.5).round();
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      return '~${duration.inHours} h ${duration.inMinutes % 60} min';
    } else if (duration.inMinutes > 0) {
      return '~${duration.inMinutes} min ${duration.inSeconds % 60} sec';
    } else {
      return '~${duration.inSeconds} sec';
    }
  }

  Widget _buildUserStakingInfo(
    BuildContext context,
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
  ) {
    final hasDelegation = (double.tryParse(stake.delegAmt) ?? 0) > 0;
    final (liquidRewards, hasLiquidRewards) =
        _calculateLiquidStakingRewards(appState);
    final hasClaimableAmount =
        (BigInt.tryParse(stake.claimableAmount) ?? BigInt.zero) > BigInt.zero;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryPurple.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.primaryPurple.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.primaryPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/piggy.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            theme.primaryPurple, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isLiquidStaking
                            ? stake.token?.symbol ?? ""
                            : l10n.stakedAmount,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildAmountDisplay(
                  theme,
                  isLiquidStaking
                      ? _formatTokenAmount(
                          stake.delegAmt,
                          appState,
                          isLSTToken: true,
                        )
                      : _formatTokenAmount(stake.delegAmt, appState),
                  hasDelegation ? theme.primaryPurple : theme.textSecondary,
                ),
                if (isLiquidStaking && hasLiquidRewards) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.success.withValues(alpha: 0.1),
                          theme.success.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.success.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/trophy.svg',
                                width: 14,
                                height: 14,
                                colorFilter: ColorFilter.mode(
                                    theme.success, BlendMode.srcIn),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.rewardsProgressTitle,
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '+',
                              style: TextStyle(
                                color: theme.success,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              liquidRewards,
                              style: TextStyle(
                                color: theme.success,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'backed ZIL',
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasClaimableAmount) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.warning.withValues(alpha: 0.1),
                          theme.warning.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.warning.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/trophy.svg',
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                                theme.warning, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Claimable Amount',
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTokenAmount(
                                        stake.claimableAmount, appState,
                                        isLSTToken: true)
                                    .$1,
                                style: TextStyle(
                                  color: theme.warning,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: l10n.claimButton,
                          onPressed: () =>
                              _claimClaimableAmount(context, appState),
                          backgroundColor: theme.warning,
                          textColor: theme.buttonText,
                          height: 32,
                          width: 60,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiquidStakingInfo(
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryPurple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryPurple.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AsyncImage(
                  url: processTokenLogo(
                    token: stake.token!,
                    shortName: appState.chain?.shortName ?? '',
                    theme: theme.value,
                  ),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorWidget: Blockies(
                    seed: stake.token!.addr,
                    color: theme.secondaryPurple,
                    bgColor: theme.primaryPurple,
                    spotColor: theme.background,
                    size: 8,
                  ),
                  loadingWidget: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${stake.token?.symbol ?? ""} (${stake.token?.name ?? ""})",
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatLSTPrice(appState),
                      style: TextStyle(
                        color: theme.primaryPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(
    AppTheme theme,
    (String, String) values,
    Color valueColor,
  ) {
    final primaryValue = values.$1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          primaryValue,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.textSecondary.withValues(alpha: 0.08),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            theme,
            "UPTIME",
            "${stake.uptime}%",
            stake.votePower == null || stake.votePower == 0
                ? theme.textSecondary
                : theme.primaryPurple,
          ),
          _buildStatItem(
            theme,
            l10n.nodes,
            stake.validators.length.toString(),
            theme.primaryPurple,
          ),
          _buildStatItem(
            theme,
            isLiquidStaking ? 'APR' : l10n.aprLabel,
            stake.apr == null || stake.apr == 0
                ? l10n.durationNotAvailable
                : '${stake.apr?.toStringAsFixed(1)}%',
            stake.apr == null || stake.apr == 0
                ? theme.textSecondary
                : theme.success,
          ),
          _buildStatItem(
            theme,
            l10n.commissionLabel,
            stake.commission == null || stake.commission == 0
                ? l10n.durationNotAvailable
                : '${stake.commission?.toStringAsFixed(1)}%',
            stake.commission == null || stake.commission == 0
                ? theme.textSecondary
                : theme.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      AppTheme theme, String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClaimRewardsButton(
    BuildContext context,
    AppTheme theme,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.success.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/trophy.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(theme.success, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rewardsAvailable,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTokenAmount(stake.rewards, appState).$1,
                  style: TextStyle(
                    color: theme.success,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            text: l10n.claimButton,
            onPressed: () => _claimRewards(context, appState),
            textColor: theme.buttonText,
            backgroundColor: theme.success,
            borderRadius: 12,
            height: 40.0,
            width: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    bool hasDelegation,
  ) {
    final theme = appState.currentTheme;

    if (isScilla && !hasDelegation) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (!isScilla) ...[
          Expanded(
            child: CustomButton(
              text: l10n.stakeButton,
              disabled: !stake.canStake,
              onPressed: () => _stake(context),
              textColor: theme.buttonText,
              backgroundColor: theme.primaryPurple,
              borderRadius: 16,
              height: 48.0,
            ),
          ),
          if (hasDelegation) const SizedBox(width: 12),
        ],
        if (hasDelegation) ...[
          Expanded(
            child: CustomButton(
              text: l10n.unstakeButton,
              onPressed: () => _initUnstake(context, appState),
              textColor: theme.buttonText,
              backgroundColor: theme.danger,
              borderRadius: 16,
              height: 48.0,
            ),
          ),
        ],
      ],
    );
  }

  (String, String) _formatTokenAmount(
    String amount,
    AppState appState, {
    bool isLSTToken = false,
  }) {
    final parsedAmount = BigInt.tryParse(amount) ?? BigInt.zero;

    if (isLSTToken && stake.token != null) {
      final token = stake.token!;
      final (formattedValue, converted) = formatingAmount(
        amount: parsedAmount,
        symbol: token.symbol,
        decimals: token.decimals,
        rate: token.rate,
        appState: appState,
        compact: true,
      );
      return (formattedValue, converted);
    } else {
      final nativeToken = appState.wallet?.tokens.firstWhere(
        (t) => t.native,
      );

      if (stake.token != null) {
        final (formattedValue, converted) = formatingAmount(
          amount: parsedAmount,
          symbol: stake.token!.symbol,
          decimals: stake.token!.decimals,
          rate: 0.0,
          appState: appState,
          compact: true,
        );
        return (formattedValue, converted);
      } else if (nativeToken != null) {
        int decimals = isScilla ? 12 : 18;

        final (formattedValue, converted) = formatingAmount(
          amount: parsedAmount,
          symbol: nativeToken.symbol,
          decimals: decimals,
          rate: 0,
          appState: appState,
          compact: true,
        );
        return (formattedValue, converted);
      }
    }

    return ("0", "0");
  }

  String _formatLSTPrice(AppState appState) {
    final price = stake.token?.rate ?? 1.0;
    final nativeToken = appState.wallet?.tokens.firstWhere(
      (t) => t.native,
    );

    final symbol = nativeToken?.symbol ?? "ZIL";

    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(2)}K $symbol';
    } else if (price >= 1) {
      return '${price.toStringAsFixed(4)} $symbol';
    } else {
      return '${price.toStringAsFixed(6)} $symbol';
    }
  }

  Future<void> _showErrorDialog(
      BuildContext context, AppState appState, Object e) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appState.currentTheme.cardBackground,
        title: Text(
          "Error",
          style: TextStyle(color: appState.currentTheme.textPrimary),
        ),
        content: Text(
          e.toString(),
          style: TextStyle(color: appState.currentTheme.danger),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "OK",
              style: TextStyle(color: appState.currentTheme.primaryPurple),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _initUnstake(BuildContext context, AppState appState) async {
    try {
      final nativeToken = appState.wallet?.tokens.firstWhere(
        (t) => t.native,
        orElse: () => throw Exception('Native token not found'),
      );
      final walletIndex = BigInt.from(appState.selectedWallet);
      final accountIndex = appState.wallet!.selectedAccount;
      TransactionRequestInfo tx;

      if ((isScilla) && appState.account!.addrType == 1) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      } else if (isEVM && appState.account!.addrType == 0) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      }

      if (isScilla) {
        tx = await buildTxScillaInitUnstake(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else if (isEVM) {
        showStakeModal(
          opType: StakeOperationType.unstake,
          context: context,
          stake: stake,
        );

        return;
      } else {
        throw "invalid tx type";
      }

      showConfirmTransactionModal(
        context: context,
        tx: tx,
        to: stake.address,
        token: nativeToken!,
        amount: "0",
        onConfirm: (_) {
          Navigator.of(context).pushNamed('/', arguments: {
            'selectedIndex': 1,
          });
        },
      );
    } catch (e) {
      _showErrorDialog(context, appState, e);
    }
  }

  void _stake(BuildContext context) {
    showStakeModal(
      opType: StakeOperationType.stake,
      context: context,
      stake: stake,
    );
  }

  Future<void> _claimWithdrawal(
    BuildContext context,
    AppState appState,
    PendingWithdrawalInfo item,
  ) async {
    try {
      final nativeToken = appState.wallet?.tokens.firstWhere(
        (t) => t.native,
        orElse: () => throw Exception('Native token not found'),
      );
      final walletIndex = BigInt.from(appState.selectedWallet);
      final accountIndex = appState.wallet!.selectedAccount;
      TransactionRequestInfo tx;

      if (isScilla && appState.account!.addrType == 1) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      } else if (isEVM && appState.account!.addrType == 0) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      }

      if (isScilla) {
        tx = await buildTxScillaCompleteWithdrawal(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else if (isEVM) {
        tx = await buildTxClaimUnstakeRequest(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else {
        throw "Invalid stake type for claiming withdrawal";
      }

      showConfirmTransactionModal(
        context: context,
        tx: tx,
        to: stake.address,
        token: nativeToken!,
        amount: "0",
        onConfirm: (_) {
          Navigator.of(context).pushNamed('/', arguments: {
            'selectedIndex': 1,
          });
        },
      );
    } catch (e) {
      _showErrorDialog(context, appState, e);
    }
  }

  Future<void> _claimRewards(BuildContext context, AppState appState) async {
    try {
      final nativeToken = appState.wallet?.tokens.firstWhere(
        (t) => t.native,
        orElse: () => throw Exception('Native token not found'),
      );
      final walletIndex = BigInt.from(appState.selectedWallet);
      final accountIndex = appState.wallet!.selectedAccount;
      TransactionRequestInfo tx;

      if (isScilla && appState.account!.addrType == 1) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      } else if (isEVM && appState.account!.addrType == 0) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      }

      if (isScilla) {
        tx = await buildClaimScillaStakingRewardsTx(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else if (isEVM) {
        tx = await buildTxClaimRewardRequest(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else {
        throw "Invlid stake type";
      }

      showConfirmTransactionModal(
        context: context,
        tx: tx,
        to: stake.address,
        token: stake.token ?? nativeToken!,
        amount: "0",
        onConfirm: (_) {
          Navigator.of(context).pushNamed('/', arguments: {
            'selectedIndex': 1,
          });
        },
      );
    } catch (e) {
      _showErrorDialog(context, appState, e);
    }
  }

  Future<void> _claimClaimableAmount(
    BuildContext context,
    AppState appState,
  ) async {
    try {
      final nativeToken = appState.wallet?.tokens.firstWhere(
        (t) => t.native,
        orElse: () => throw Exception('Native token not found'),
      );
      final walletIndex = BigInt.from(appState.selectedWallet);
      final accountIndex = appState.wallet!.selectedAccount;
      TransactionRequestInfo tx;

      if (isEVM && appState.account!.addrType == 0) {
        await zilliqaSwapChain(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
        );
      }

      if (isEVM) {
        tx = await buildTxClaimUnstakeRequest(
          walletIndex: walletIndex,
          accountIndex: accountIndex,
          stake: stake,
        );
      } else {
        throw "Invalid stake type for claiming claimable amount";
      }

      showConfirmTransactionModal(
        context: context,
        tx: tx,
        to: stake.address,
        token: stake.token ?? nativeToken!,
        amount: "0",
        onConfirm: (_) {
          Navigator.of(context).pushNamed('/', arguments: {
            'selectedIndex': 1,
          });
        },
      );
    } catch (e) {
      _showErrorDialog(context, appState, e);
    }
  }

  (String, bool) _calculateLiquidStakingRewards(AppState appState) {
    if (!isLiquidStaking || stake.token?.rate == null) {
      return ("0", false);
    }

    final lstAmount = BigInt.tryParse(stake.delegAmt) ?? BigInt.zero;
    if (lstAmount == BigInt.zero) {
      return ("0", false);
    }

    final lstPrice = stake.token!.rate;
    final decimals = stake.token!.decimals;

    final lstAmountDouble = lstAmount.toDouble() / pow(10, decimals);
    final zilBackedDouble = lstAmountDouble * lstPrice;
    final rewardsEarnedDouble = zilBackedDouble - lstAmountDouble;

    if (rewardsEarnedDouble <= 0) {
      return ("0", false);
    }

    final nativeToken = appState.wallet?.tokens.firstWhere((t) => t.native);
    final nativeDecimals = nativeToken?.decimals ?? 18;

    final rewardsBigInt =
        BigInt.from(rewardsEarnedDouble * pow(10, nativeDecimals));

    final (formattedRewards, _) = formatingAmount(
      amount: rewardsBigInt,
      symbol: nativeToken?.symbol ?? 'ZIL',
      decimals: nativeDecimals,
      rate: 0,
      appState: appState,
      compact: true,
    );

    return (formattedRewards, true);
  }
}
