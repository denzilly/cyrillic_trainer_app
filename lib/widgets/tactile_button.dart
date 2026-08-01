import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A button with a solid face and a darker "3D lip" along the bottom edge,
/// per the design system's tactile/squishy button spec. On press, the face
/// shifts down into the lip (lip visually shrinks from 4px to 2px) without
/// changing the button's overall footprint.
class TactileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color? lipColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const TactileButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = AppColors.primary,
    this.lipColor,
    this.foregroundColor,
    this.borderRadius = AppRadius.lg,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  static const _restLip = 4.0;
  static const _pressedLip = 2.0;
  static const _animationDuration = Duration(milliseconds: 80);

  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final lipColor = widget.lipColor ?? _darken(widget.color, 0.22);
    final faceColor = enabled ? widget.color : widget.color.withValues(alpha: 0.5);
    final currentLip = _pressed ? _pressedLip : _restLip;
    final foreground = widget.foregroundColor ?? AppColors.onPrimary;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        padding: EdgeInsets.only(top: _restLip - currentLip),
        decoration: BoxDecoration(
          color: lipColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOut,
          margin: EdgeInsets.only(bottom: currentLip),
          padding: widget.padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: faceColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
            child: IconTheme.merge(
              data: IconThemeData(color: foreground),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

Color _darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darker.toColor();
}
