import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The CJ monogram. Geometry mirrors images/brand/logo.svg (512-unit grid).
class BrandLogo extends StatelessWidget {
  final double size;
  const BrandLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) => Semantics(
        label: "CJ logo",
        child: CustomPaint(size: Size.square(size), painter: _LogoPainter()),
      );
}

class _LogoPainter extends CustomPainter {
  static const _deg = math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 512);
    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;

    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 512, 512), const Radius.circular(96)),
      Paint()..color = Brand.navy,
    );
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(214, 256), radius: 112),
      -48 * _deg,
      -264 * _deg,
      false,
      stroke(Colors.white, 56),
    );
    final j = Path()
      ..moveTo(352, 144)
      ..lineTo(352, 296)
      ..arcTo(Rect.fromCircle(center: const Offset(296, 296), radius: 56), 0, math.pi, false);
    canvas.drawPath(j, stroke(Brand.navy, 84)); // knocks a gap out of the C where the J crosses
    canvas.drawPath(j, stroke(Brand.copper, 56));
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}

/// Logo + name, used in the navbar and footer.
class BrandLockup extends StatelessWidget {
  final double size;
  const BrandLockup({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandLogo(size: size),
          const SizedBox(width: 12),
          Text("Canaan Ozah",
              style: context.text.titleMedium!.copyWith(fontWeight: FontWeight.w600, letterSpacing: -0.2)),
        ],
      );
}
