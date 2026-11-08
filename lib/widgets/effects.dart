import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Calls [onFirstVisible] once, the first time the widget scrolls into view.
mixin _FirstVisible<T extends StatefulWidget> on State<T> {
  ScrollPosition? _position;
  bool _seen = false;

  void onFirstVisible();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    if (!_seen) _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_seen || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    if (box.localToGlobal(Offset.zero).dy < MediaQuery.sizeOf(context).height * 0.95) {
      _seen = true;
      _position?.removeListener(_check);
      onFirstVisible();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }
}

/// Rebuilds with `seen == true` once the widget first scrolls into view.
class VisibleBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool seen) builder;
  const VisibleBuilder({super.key, required this.builder});

  @override
  State<VisibleBuilder> createState() => _VisibleBuilderState();
}

class _VisibleBuilderState extends State<VisibleBuilder> with _FirstVisible {
  bool _visible = false;

  @override
  void onFirstVisible() => setState(() => _visible = true);

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _visible || MediaQuery.disableAnimationsOf(context));
}

/// Fades and rises its child the first time it scrolls into view.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  /// Swing up in 3D as it arrives (for cards).
  final bool flip;
  const Reveal({super.key, required this.child, this.delay = Duration.zero, this.flip = false});

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin, _FirstVisible {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void onFirstVisible() => Future.delayed(widget.delay, () => mounted ? _c.forward() : null);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeOutQuint);
    return AnimatedBuilder(
      animation: curve,
      child: widget.child,
      builder: (_, child) {
        final rest = 1 - curve.value;
        return Opacity(
          opacity: curve.value,
          child: ImageFiltered(
            // Same widget tree when finished, so children keep their state.
            enabled: rest > 0.01,
            imageFilter: ImageFilter.blur(sigmaX: 7 * rest, sigmaY: 7 * rest),
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                // Perspective only while flipping: left on, it would stack onto 3D children at rest.
                ..setEntry(3, 2, widget.flip && rest > 0 ? 0.0014 : 0)
                ..translateByDouble(0, 28 * rest, 0, 1)
                ..rotateX(widget.flip ? 0.42 * rest : 0)
                ..scaleByDouble(1 - 0.03 * rest, 1 - 0.03 * rest, 1, 1),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Fades and slides its child in when it mounts, after a short index-based delay.
class StaggerIn extends StatelessWidget {
  static const _stepMs = 55, _riseMs = 420;
  final int index;
  final Widget child;
  const StaggerIn({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final total = _riseMs + _stepMs * index;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      child: child,
      builder: (_, t, child) {
        final v = Interval(_stepMs * index / total, 1, curve: Curves.easeOutCubic).transform(t);
        return Opacity(opacity: v, child: Transform.translate(offset: Offset(18 * (1 - v), 0), child: child));
      },
    );
  }
}

/// How far a magnetic element leans toward the cursor; [local] is inside a box of [size].
Offset magnetPull(Offset local, Size size, {double strength = 0.24, double max = 8}) {
  final x = (local.dx - size.width / 2) * strength;
  final y = (local.dy - size.height / 2) * strength;
  return Offset(x.clamp(-max, max), y.clamp(-max, max));
}

/// Leans toward the cursor while hovered, then springs back.
class Magnetic extends StatefulWidget {
  final Widget child;
  const Magnetic({super.key, required this.child});

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic> {
  Offset _pull = Offset.zero;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return MouseRegion(
      onHover: (e) => setState(() => _pull = magnetPull(e.localPosition, (context.findRenderObject() as RenderBox).size)),
      onExit: (_) => setState(() => _pull = Offset.zero),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: _pull),
        duration: Duration(milliseconds: _pull == Offset.zero ? 420 : 140),
        curve: _pull == Offset.zero ? Curves.elasticOut : Curves.easeOut,
        child: widget.child,
        builder: (_, o, child) => Transform.translate(offset: o, child: child),
      ),
    );
  }
}

/// A band of light that sweeps across its child every few seconds while on screen.
class _Sheen extends StatefulWidget {
  final Widget child;
  const _Sheen({required this.child});

  @override
  State<_Sheen> createState() => _SheenState();
}

class _SheenState extends State<_Sheen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
  Timer? _timer;

  void _sweep() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.attached && box.localToGlobal(Offset.zero).dy > 0) _c.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      _sweep();
      _timer = Timer.periodic(const Duration(seconds: 6), (_) => _sweep());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (_, child) {
          final p = Curves.easeInOut.transform(_c.value);
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (r) => LinearGradient(
              begin: Alignment(-3 + 6 * p, 0),
              end: Alignment(-1 + 6 * p, 0),
              colors: [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: 0.65), Colors.white.withValues(alpha: 0)],
            ).createShader(r),
            child: child,
          );
        },
      );
}

/// Headline whose words rise out of a mask one after another.
class WordReveal extends StatefulWidget {
  final String text;
  final TextStyle style;

  /// Words from this index on are drawn in [accent].
  final int? accentFrom;
  final Color? accent;
  const WordReveal(this.text, {super.key, required this.style, this.accentFrom, this.accent});

  @override
  State<WordReveal> createState() => _WordRevealState();
}

class _WordRevealState extends State<WordReveal> with SingleTickerProviderStateMixin, _FirstVisible {
  static const _stepMs = 65, _riseMs = 620;
  late final _words = widget.text.split(" ");
  late final _totalMs = _riseMs + _stepMs * (_words.length - 1);
  late final AnimationController _c =
      AnimationController(vsync: this, duration: Duration(milliseconds: _totalMs));

  @override
  void onFirstVisible() => _c.forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: widget.text,
      child: ExcludeSemantics(
        child: Wrap(
          spacing: (widget.style.fontSize ?? 16) * 0.26,
          children: [
            for (var i = 0; i < _words.length; i++)
              AnimatedBuilder(
                animation: _c,
                builder: (_, __) {
                  final t = still
                      ? 1.0
                      : Interval(
                          i * _stepMs / _totalMs,
                          (i * _stepMs + _riseMs) / _totalMs,
                          curve: Curves.easeOutQuint,
                        ).transform(_c.value);
                  final accented = widget.accentFrom != null && i >= widget.accentFrom!;
                  // Unclipped once done, so descenders are never cut off.
                  return ClipRect(
                    clipBehavior: _c.isCompleted || still ? Clip.none : Clip.hardEdge,
                    child: FractionalTranslation(
                      translation: Offset(0, 1.05 * (1 - t)),
                      child: accented && !still
                          ? _Sheen(child: Text(_words[i], style: widget.style.copyWith(color: widget.accent)))
                          : Text(
                              _words[i],
                              style: accented ? widget.style.copyWith(color: widget.accent) : widget.style,
                            ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Counts up to [value] the first time it scrolls into view.
class CountUp extends StatefulWidget {
  final int value;
  final String suffix;
  final TextStyle? style;
  const CountUp({super.key, required this.value, this.suffix = "", this.style});

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin, _FirstVisible {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

  @override
  void onFirstVisible() => _c.forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finalText = "${widget.value}${widget.suffix}";
    if (MediaQuery.disableAnimationsOf(context)) return Text(finalText, style: widget.style);
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeOutExpo);
    return Semantics(
      label: finalText,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: curve,
          builder: (_, __) => Text(
            "${(widget.value * curve.value).round()}${widget.suffix}",
            // Fixed-width digits stop the number jittering as it counts.
            style: widget.style?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ),
      ),
    );
  }
}

/// Small breathing status dot.
class PulseDot extends StatefulWidget {
  final Color color;
  const PulseDot({super.key, this.color = const Color(0xFF22A06B)});

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MediaQuery.disableAnimationsOf(context) ? _c.stop() : _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 16,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => Stack(alignment: Alignment.center, children: [
              Container(
                width: 6 + 10 * _c.value,
                height: 6 + 10 * _c.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.35 * (1 - _c.value)),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
              ),
            ]),
          ),
        ),
      );
}

/// Interactive card: lifts on hover, with a soft light and glowing edge under the cursor.
class HoverLift extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const HoverLift({super.key, required this.child, this.onTap});

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  final _pointer = ValueNotifier<Offset>(Offset.zero);
  bool _hover = false;

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      onHover: (e) => _pointer.value = e.localPosition,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _hover && !still ? 1 : 0),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: widget.child,
          ),
        ),
        builder: (_, t, child) => Transform.translate(
          offset: Offset(0, -5 * t),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12 * t),
                  blurRadius: 32,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: CustomPaint(foregroundPainter: _Spotlight(_pointer, t), child: child),
          ),
        ),
      ),
    );
  }
}

class _Spotlight extends CustomPainter {
  final ValueNotifier<Offset> pointer;
  final double t;
  _Spotlight(this.pointer, this.t) : super(repaint: pointer);

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0) return;
    final bounds = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(bounds.deflate(0.5), const Radius.circular(12));
    Shader glow(double radius, double alpha) => RadialGradient(
          colors: [Brand.copper.withValues(alpha: alpha * t), Brand.copper.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: pointer.value, radius: radius));
    canvas.drawRRect(rrect, Paint()..shader = glow(280, 0.10));
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = glow(220, 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_Spotlight old) => old.t != t;
}

/// Plain bordered surface.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(28)});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: child,
      );
}
