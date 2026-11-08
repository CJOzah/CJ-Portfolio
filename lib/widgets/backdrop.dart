import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Full-screen animated background: drifting glow blobs, a particle network
/// that links nearby dots, and a soft spotlight that follows the pointer.
class Backdrop extends StatefulWidget {
  final ValueNotifier<Offset?> pointer;
  const Backdrop({super.key, required this.pointer});

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _clock =
      AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  final _rand = math.Random(7);
  late final List<_Particle> _particles = List.generate(
    70,
    (_) => _Particle(
      Offset(_rand.nextDouble(), _rand.nextDouble()),
      Offset(_rand.nextDouble() - 0.5, _rand.nextDouble() - 0.5) * 0.02,
      1 + _rand.nextDouble() * 1.8,
    ),
  );

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fewer particles on phones keeps it smooth.
    final count = context.isMobile ? 28 : _particles.length;
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _BackdropPainter(
          clock: _clock,
          pointer: widget.pointer,
          particles: _particles.take(count).toList(),
          dark: context.isDark,
        ),
      ),
    );
  }
}

class _Particle {
  Offset pos; // normalized 0..1
  final Offset vel; // normalized units per second
  final double r;
  _Particle(this.pos, this.vel, this.r);
}

class _BackdropPainter extends CustomPainter {
  final Animation<double> clock;
  final ValueNotifier<Offset?> pointer;
  final List<_Particle> particles;
  final bool dark;
  double _lastT = -1;

  _BackdropPainter({
    required this.clock,
    required this.pointer,
    required this.particles,
    required this.dark,
  }) : super(repaint: Listenable.merge([clock, pointer]));

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock.value * 60; // seconds within the loop
    var dt = _lastT < 0 ? 0.0 : t - _lastT;
    if (dt < 0) dt += 60; // loop wrap
    _lastT = t;

    // Drifting glows
    void glow(Offset c, double radius, Color color) {
      canvas.drawCircle(
        c,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: c, radius: radius)),
      );
    }

    final a = t / 60 * 2 * math.pi;
    final glowAlpha = dark ? 0.22 : 0.16;
    glow(
      Offset(size.width * (0.18 + 0.08 * math.sin(a * 2)), size.height * (0.25 + 0.1 * math.cos(a * 3))),
      size.shortestSide * 0.55,
      Brand.orange.withValues(alpha: glowAlpha),
    );
    glow(
      Offset(size.width * (0.85 + 0.06 * math.cos(a * 2)), size.height * (0.7 + 0.08 * math.sin(a * 4))),
      size.shortestSide * 0.6,
      (dark ? const Color(0xFF1C6E9C) : const Color(0xFF7FB8D9)).withValues(alpha: glowAlpha + 0.06),
    );

    // Particles
    final p = pointer.value;
    final dotPaint = Paint()..color = (dark ? Brand.snow : Brand.navy).withValues(alpha: 0.5);
    final points = <Offset>[];
    for (final particle in particles) {
      var next = particle.pos + particle.vel * dt;
      next = Offset(next.dx % 1, next.dy % 1);
      particle.pos = next;
      var o = Offset(next.dx * size.width, next.dy * size.height);
      if (p != null) {
        // Nudge dots gently toward the cursor.
        final d = p - o;
        final dist = d.distance;
        if (dist < 160 && dist > 0) o += d / dist * (160 - dist) * 0.15;
      }
      points.add(o);
      canvas.drawCircle(o, particle.r, dotPaint);
    }

    const linkDist = 130.0;
    final line = Paint()..strokeWidth = 0.8;
    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d < linkDist) {
          line.color = (dark ? Brand.snow : Brand.navy)
              .withValues(alpha: 0.14 * (1 - d / linkDist));
          canvas.drawLine(points[i], points[j], line);
        }
      }
      if (p != null) {
        final d = (points[i] - p).distance;
        if (d < 180) {
          line.color = Brand.orange.withValues(alpha: 0.45 * (1 - d / 180));
          canvas.drawLine(points[i], p, line);
        }
      }
    }

    if (p != null) glow(p, 220, Brand.orange.withValues(alpha: dark ? 0.10 : 0.08));
  }

  @override
  bool shouldRepaint(_BackdropPainter old) => old.dark != dark || old.particles.length != particles.length;
}
