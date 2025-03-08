import 'package:flutter/widgets.dart';

class TileButton extends StatefulWidget {
  final String? title;
  final Widget icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool disabled;

  const TileButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.title,
    this.backgroundColor = const Color(0xFF2C2C2E),
    this.textColor = const Color(0xFF9D4BFF),
    this.disabled = false,
  });

  @override
  State<TileButton> createState() => _TileButtonState();
}

class _TileButtonState extends State<TileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled) {
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    if (!widget.disabled) {
      _controller.reverse();
    }
  }

  void _handleHoverChanged(bool isHovered) {
    if (!widget.disabled) {
      setState(() {
        _isHovered = isHovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = widget.title != null && widget.title!.isNotEmpty;
    final double containerSize = hasTitle ? 72.0 : 56.0;
    final double iconSize = hasTitle ? 32.0 : 24.0;
    final double borderRadius = hasTitle ? 24.0 : 20.0;

    return MouseRegion(
      onEnter: (_) => _handleHoverChanged(true),
      onExit: (_) => _handleHoverChanged(false),
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: widget.disabled ? 0.5 : _opacityAnimation.value,
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      if (_isHovered && !widget.disabled)
                        BoxShadow(
                          color: widget.textColor.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: iconSize,
                          height: iconSize,
                          child: widget.icon,
                        ),
                        if (hasTitle) ...[
                          const SizedBox(height: 4),
                          SizedBox(
                            width: containerSize - 8,
                            child: Text(
                              widget.title!,
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
