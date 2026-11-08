import 'dart:math' as math;
import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Dot grid behind [child]: one ripple on load, then dots light up around the cursor.
/// Only repaints while something moves, so it costs nothing when idle.
class DotField extends StatefulWidget {
  final Widget child;
  const DotField({super.key, required this.child});

  @override
  State<DotField> createState() => _DotFieldState();
}

class _DotFieldState extends State<DotField> with SingleTickerProviderStateMixin {
  final _pointer = ValueNotifier<Offset?>(null);
  late final AnimationController _wave =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _wave.value = 1;
    } else if (_wave.isDismissed) {
      _wave.forward();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        opaque: false,
        onHover: (e) => _pointer.value = e.localPosition,
        onExit: (_) => _pointer.value = null,
        child: Stack(children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _DotPainter(
                  wave: _wave,
                  pointer: _pointer,
                  dot: context.colors.onSurface.withValues(alpha: 0.13),
                  background: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          widget.child,
        ]),
      );
}

class _DotPainter extends CustomPainter {
  static const _spacing = 26.0, _cursorRadius = 190.0, _ringWidth = 110.0;
  final Animation<double> wave;
  final ValueNotifier<Offset?> pointer;
  final Color dot, background;

  _DotPainter({required this.wave, required this.pointer, required this.dot, required this.background})
      : super(repaint: Listenable.merge([wave, pointer]));

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width * 0.78, size.height * 0.28);
    final ringRadius = Curves.easeOutCubic.transform(wave.value) * size.longestSide;
    final waveStrength = 1 - wave.value;
    final cursor = pointer.value;
    final plain = <Offset>[];
    final lit = Paint();

    for (var x = _spacing / 2; x < size.width; x += _spacing) {
      for (var y = _spacing / 2; y < size.height; y += _spacing) {
        final p = Offset(x, y);
        final ring = (p - origin).distance - ringRadius;
        var glow = waveStrength * math.exp(-(ring * ring) / (_ringWidth * _ringWidth));
        if (cursor != null) {
          final d = (p - cursor).distance;
          if (d < _cursorRadius) glow = math.max(glow, math.pow(1 - d / _cursorRadius, 2).toDouble());
        }
        if (glow < 0.02) {
          plain.add(p);
        } else {
          lit.color = Color.lerp(dot, Brand.copper, glow)!;
          canvas.drawCircle(p, 1.1 + 2 * glow, lit);
        }
      }
    }
    canvas.drawPoints(
      PointMode.points,
      plain,
      Paint()
        ..color = dot
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
    // Keep the grid around the phone so the copy sits on a clean background.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.55, -0.45),
          radius: 0.95,
          colors: [background.withValues(alpha: 0), background],
          stops: const [0.15, 0.85],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_DotPainter old) => old.dot != dot || old.background != background;
}
