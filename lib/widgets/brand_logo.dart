import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The CJ monogram: an orange "C" arc, a white "J" and a blinking code caret.
/// Geometry mirrors images/brand/logo.svg (512-unit grid).
class BrandLogo extends StatefulWidget {
  final double size;

  /// Draw the strokes in on first build (used by the intro splash).
  final bool animateIn;
  const BrandLogo({super.key, this.size = 40, this.animateIn = false});

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> with TickerProviderStateMixin {
  late final AnimationController _draw = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
    value: widget.animateIn ? 0 : 1,
  );
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void initState() {
    super.initState();
    if (widget.animateIn) _draw.forward();
  }

  @override
  void dispose() {
    _draw.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "CJ logo",
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _LogoPainter(
            draw: CurvedAnimation(parent: _draw, curve: Curves.easeInOutCubic),
            blink: _blink,
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Animation<double> draw;
  final Animation<double> blink;
  _LogoPainter({required this.draw, required this.blink})
      : super(repaint: Listenable.merge([draw, blink]));

  static const _deg = math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 512;
    canvas.scale(s);
    const full = Rect.fromLTWH(0, 0, 512, 512);
    final fire = Brand.fire.createShader(full);
    final p = draw.value;

    // Badge
    canvas.drawRRect(
      RRect.fromRectAndRadius(full, const Radius.circular(116)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0B3A5B), Color(0xFF021624)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(full),
    );

    // C: starts at -40deg and sweeps 280deg counter-clockwise.
    final cProgress = (p / 0.6).clamp(0.0, 1.0);
    if (cProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(256, 256), radius: 128),
        -40 * _deg,
        -280 * _deg * cProgress,
        false,
        Paint()
          ..shader = fire
          ..style = PaintingStyle.stroke
          ..strokeWidth = 44
          ..strokeCap = StrokeCap.round,
      );
    }

    // J: stem then hook, drawn after the C has mostly finished.
    final jProgress = ((p - 0.35) / 0.55).clamp(0.0, 1.0);
    if (jProgress > 0) {
      final j = Path()
        ..moveTo(290, 190)
        ..lineTo(290, 286)
        ..arcTo(Rect.fromCircle(center: const Offset(250, 286), radius: 40), 0,
            math.pi, false);
      for (final metric in j.computeMetrics()) {
        canvas.drawPath(
          metric.extractPath(0, metric.length * jProgress),
          Paint()
            ..color = Brand.snow
            ..style = PaintingStyle.stroke
            ..strokeWidth = 40
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Caret: appears at the end, then blinks.
    if (p >= 0.95) {
      final on = blink.value < 0.55;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(358, 212, 28, 88), const Radius.circular(10)),
        Paint()
          ..shader = fire
          ..color = Colors.white.withValues(alpha: on ? 1 : 0.15),
      );
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}

/// Logo + wordmark used in the navbar and footer.
class BrandLockup extends StatelessWidget {
  final double size;
  const BrandLockup({super.key, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandLogo(size: size),
        const SizedBox(width: 12),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: "cj"),
            TextSpan(text: ".", style: TextStyle(color: Brand.orange)),
            const TextSpan(text: "ozah"),
          ]),
          style: context.text.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
