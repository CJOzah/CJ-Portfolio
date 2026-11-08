import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The CJ monogram. Geometry mirrors images/brand/logo.svg (512-unit grid).
class BrandLogo extends StatefulWidget {
  final double size;

  /// Draw the letterforms in once when first shown.
  final bool drawIn;
  const BrandLogo({super.key, this.size = 40, this.drawIn = false});

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100), value: widget.drawIn ? 0 : 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.value = 1;
    } else if (_c.isDismissed) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: "CJ logo",
        child: CustomPaint(size: Size.square(widget.size), painter: _LogoPainter(_c)),
      );
}

class _LogoPainter extends CustomPainter {
  final Animation<double> draw;
  _LogoPainter(this.draw) : super(repaint: draw);

  static const _deg = math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 512);
    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;
    final c = Curves.easeInOutCubic.transform((draw.value / 0.62).clamp(0.0, 1.0));
    final j = Curves.easeInOutCubic.transform(((draw.value - 0.38) / 0.62).clamp(0.0, 1.0));

    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 512, 512), const Radius.circular(96)),
      Paint()..color = Brand.navy,
    );
    if (c > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(214, 256), radius: 112),
        -48 * _deg,
        -264 * _deg * c,
        false,
        stroke(Colors.white, 56),
      );
    }
    if (j > 0) {
      final metric = (Path()
            ..moveTo(352, 144)
            ..lineTo(352, 296)
            ..arcTo(Rect.fromCircle(center: const Offset(296, 296), radius: 56), 0, math.pi, false))
          .computeMetrics()
          .first;
      final path = metric.extractPath(0, metric.length * j);
      canvas.drawPath(path, stroke(Brand.navy, 84)); // knocks a gap out of the C where the J crosses
      canvas.drawPath(path, stroke(Brand.copper, 56));
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}

/// Logo + name, used in the navbar and footer.
class BrandLockup extends StatelessWidget {
  final double size;
  final bool drawIn;
  const BrandLockup({super.key, this.size = 32, this.drawIn = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandLogo(size: size, drawIn: drawIn),
          const SizedBox(width: 12),
          Text("Canaan Ozah",
              style: context.text.titleMedium!.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.2)),
        ],
      );
}
