import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zilpay/state/app_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback onBackPressed;
  final VoidCallback? onActionPressed;
  final Widget? actionIcon;
  final Widget? actionWidget;

  const CustomAppBar({
    super.key,
    required this.onBackPressed,
    this.title,
    this.onActionPressed,
    this.actionIcon,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).currentTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: onBackPressed,
            ),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: theme.headline2.copyWith(
                    color: theme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (actionWidget != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: actionWidget!,
              )
            else if (actionIcon != null && onActionPressed != null)
              IconButton(
                icon: actionIcon!,
                onPressed: onActionPressed,
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
