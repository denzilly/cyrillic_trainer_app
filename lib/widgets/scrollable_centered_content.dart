import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centers [child] in the available space, but scrolls instead of
/// overflowing when the content (or an open keyboard) doesn't fit —
/// e.g. on small screens, in landscape, or with large accessibility
/// text scaling.
class ScrollableCenteredContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ScrollableCenteredContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.marginMobile,
      vertical: AppSpacing.gutter,
    ),
    this.maxWidth = AppSpacing.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}
