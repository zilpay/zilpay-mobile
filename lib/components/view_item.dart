import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/state/app_state.dart';

class WalletListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final dynamic icon;
  final VoidCallback? onTap;
  final bool disabled;

  const WalletListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  @override
  State<WalletListItem> createState() => _WalletListItemState();
}

class _WalletListItemState extends State<WalletListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).currentTheme;
    final opacity = widget.disabled ? 0.5 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => _controller.forward(),
        onTapUp: widget.disabled ? null : (_) => _controller.reverse(),
        onTapCancel: widget.disabled ? null : () => _controller.reverse(),
        onTap: widget.disabled ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.disabled ? 1.0 : _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardBackground.withValues(
                    alpha: widget.disabled ? opacity : _opacityAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Opacity(opacity: opacity, child: _buildIcon()),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: theme.bodyText1.copyWith(
                          color: theme.textPrimary.withValues(alpha: opacity),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: theme.bodyText2.copyWith(
                          color: theme.textSecondary.withValues(alpha: opacity),
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: opacity,
                  child: SvgPicture.asset(
                    'assets/icons/chevron_right.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      theme.textSecondary,
                      BlendMode.srcIn,
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

  Widget _buildIcon() {
    if (widget.icon is IconData) {
      return Icon(widget.icon as IconData);
    } else if (widget.icon is Widget) {
      return widget.icon;
    } else if (widget.icon is String) {
      return Image.asset(
        widget.icon,
        width: 24,
        height: 24,
      );
    }
    return Container();
  }
}
