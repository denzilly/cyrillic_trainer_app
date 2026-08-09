import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Wraps the whole app shell in a very subtle, continuously drifting field
/// of oversized, low-opacity Cyrillic letters — decoration only, meant to
/// keep the plain [AppColors.surface] background from feeling static.
///
/// This sits above [MaterialApp]'s [Navigator] via `MaterialApp.builder`, so
/// it's a single long-running animation shared by every screen instead of
/// each screen starting its own. For it to actually show through, every
/// screen's [Scaffold] relies on a transparent
/// [ThemeData.scaffoldBackgroundColor] (set in [buildAppTheme]) — this
/// widget paints the real surface color as its base layer instead.
class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Reduced-motion users still get the (static) letters for texture, just
    // no drift.
    if (!MediaQuery.of(context).disableAnimations) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Stack(
        children: [
          // Decorative and non-interactive: hidden from screen readers and
          // never intercepts touches meant for the real content above it.
          Positioned.fill(
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _DriftingLettersPainter(_controller.value),
                  ),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

enum _Tint { primary, accent }

/// One drifting letter's fixed traits. Anchor points are hand-placed (not
/// randomized) so the layout is stable across rebuilds and hot reloads, and
/// speeds/phases are deliberately uneven so the letters never fall into
/// sync with each other.
class _Drifter {
  final String glyph;
  final Alignment anchor;
  final double fontSize;
  final double driftRadius;
  final double driftSpeed;
  final double phase;
  final double rotationAmplitude;
  final _Tint tint;

  const _Drifter({
    required this.glyph,
    required this.anchor,
    required this.fontSize,
    required this.driftRadius,
    required this.driftSpeed,
    required this.phase,
    required this.rotationAmplitude,
    required this.tint,
  });
}

/// Cyrillic-only glyphs (no Latin lookalikes) so they read unambiguously as
/// "this is a Cyrillic app" even at a glance, scattered towards the edges
/// to stay out of the way of centered content.
const _drifters = [
  _Drifter(
    glyph: 'Ф',
    anchor: Alignment(-0.85, -0.75),
    fontSize: 120,
    driftRadius: 26,
    driftSpeed: 0.8,
    phase: 0.0,
    rotationAmplitude: 0.05,
    tint: _Tint.primary,
  ),
  _Drifter(
    glyph: 'Ж',
    anchor: Alignment(0.8, -0.55),
    fontSize: 96,
    driftRadius: 32,
    driftSpeed: 1.1,
    phase: 1.4,
    rotationAmplitude: 0.08,
    tint: _Tint.accent,
  ),
  _Drifter(
    glyph: 'Ю',
    anchor: Alignment(-0.75, 0.15),
    fontSize: 140,
    driftRadius: 22,
    driftSpeed: 0.65,
    phase: 2.6,
    rotationAmplitude: 0.04,
    tint: _Tint.primary,
  ),
  _Drifter(
    glyph: 'Щ',
    anchor: Alignment(0.85, 0.4),
    fontSize: 108,
    driftRadius: 30,
    driftSpeed: 0.95,
    phase: 3.9,
    rotationAmplitude: 0.07,
    tint: _Tint.accent,
  ),
  _Drifter(
    glyph: 'Я',
    anchor: Alignment(-0.15, -0.92),
    fontSize: 86,
    driftRadius: 24,
    driftSpeed: 1.25,
    phase: 5.1,
    rotationAmplitude: 0.06,
    tint: _Tint.primary,
  ),
  _Drifter(
    glyph: 'Б',
    anchor: Alignment(0.1, 0.9),
    fontSize: 130,
    driftRadius: 28,
    driftSpeed: 0.7,
    phase: 0.7,
    rotationAmplitude: 0.05,
    tint: _Tint.accent,
  ),
];

class _DriftingLettersPainter extends CustomPainter {
  final double t;

  _DriftingLettersPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final drifter in _drifters) {
      final angle = 2 * math.pi * (t * drifter.driftSpeed + drifter.phase);
      final dx = math.cos(angle) * drifter.driftRadius;
      final dy = math.sin(angle * 0.7) * drifter.driftRadius * 0.6;
      final rotation = math.sin(angle) * drifter.rotationAmplitude;

      final center = drifter.anchor.alongSize(size) + Offset(dx, dy);
      final color =
          (drifter.tint == _Tint.primary ? AppColors.primary : AppColors.accent)
              .withValues(alpha: 0.07);

      final textPainter = TextPainter(
        text: TextSpan(
          text: drifter.glyph,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: drifter.fontSize,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DriftingLettersPainter oldDelegate) =>
      oldDelegate.t != t;
}
