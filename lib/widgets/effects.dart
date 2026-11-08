import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_theme.dart';

/// Fades + slides its child in the first time it scrolls into view.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset from;
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = const Offset(0, 40),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
  ScrollPosition? _position;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.92) {
      setState(() => _started = true);
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: curve,
      // Remount on reveal so implicit animations inside (e.g. CountUp) start when visible.
      child: KeyedSubtree(key: ValueKey(_started), child: widget.child),
      builder: (_, child) => Opacity(
        opacity: curve.value,
        child: Transform.translate(offset: widget.from * (1 - curve.value), child: child),
      ),
    );
  }
}

/// Lifts, glows and (optionally) 3D-tilts toward the pointer on hover.
class HoverLift extends StatefulWidget {
  final Widget child;
  final bool tilt;
  final BorderRadius radius;
  final VoidCallback? onTap;
  const HoverLift({
    super.key,
    required this.child,
    this.tilt = false,
    this.radius = const BorderRadius.all(Radius.circular(24)),
    this.onTap,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;
  Offset _tilt = Offset.zero; // -1..1 on each axis

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _tilt = Offset.zero;
      }),
      onHover: widget.tilt
          ? (e) {
              final size = (context.findRenderObject() as RenderBox).size;
              setState(() => _tilt = Offset(
                    (e.localPosition.dx / size.width) * 2 - 1,
                    (e.localPosition.dy / size.height) * 2 - 1,
                  ));
            }
          : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: _hover ? 1 : 0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          builder: (_, t, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..translateByDouble(0, -8 * t, 0, 1)
              ..rotateX(-_tilt.dy * 0.08 * t)
              ..rotateY(_tilt.dx * 0.08 * t),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.radius,
                boxShadow: [
                  BoxShadow(
                    color: Brand.orange.withValues(alpha: 0.28 * t),
                    blurRadius: 40,
                    spreadRadius: -6,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: child,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Glassy surface card with a hairline border.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlight;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.035)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlight ? Brand.orange.withValues(alpha: 0.5) : on.withValues(alpha: 0.08),
        ),
      ),
      child: child,
    );
  }
}

/// Text painted with the brand fire gradient.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const GradientText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: Brand.fire.createShader,
        child: Text(text, style: style),
      );
}

/// Types each phrase, pauses, deletes it, then moves to the next.
class Typewriter extends StatefulWidget {
  final List<String> phrases;
  final TextStyle? style;
  const Typewriter({super.key, required this.phrases, this.style});

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter> {
  int _phrase = 0, _chars = 0;
  bool _deleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() {
    final word = widget.phrases[_phrase];
    Duration next = Duration(milliseconds: _deleting ? 35 : 70);
    setState(() {
      if (!_deleting && _chars == word.length) {
        _deleting = true;
        next = const Duration(milliseconds: 1600);
      } else if (_deleting && _chars == 0) {
        _deleting = false;
        _phrase = (_phrase + 1) % widget.phrases.length;
      } else {
        _chars += _deleting ? -1 : 1;
      }
    });
    _timer = Timer(next, _tick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.phrases[_phrase];
    return Semantics(
      label: word,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: GradientText(word.substring(0, _chars.clamp(0, word.length)),
                  style: widget.style),
            ),
            const _Caret(),
          ],
        ),
      ),
    );
  }
}

class _Caret extends StatefulWidget {
  const _Caret();
  @override
  State<_Caret> createState() => _CaretState();
}

class _CaretState extends State<_Caret> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
        ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _c,
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          width: 4,
          height: 30,
          decoration: BoxDecoration(
              gradient: Brand.fire, borderRadius: BorderRadius.circular(2)),
        ),
      );
}

/// Infinite horizontal ticker: an endless lazy ListView scrolled by a ticker.
class Marquee extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final double speed; // px per second
  const Marquee({super.key, required this.children, this.height = 40, this.speed = 50});

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((now) {
      final dt = (now - _last).inMicroseconds / 1e6;
      _last = now;
      if (_scroll.hasClients && _scroll.position.hasContentDimensions) _scroll.jumpTo(_scroll.offset + widget.speed * dt);
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        child: ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
            stops: [0, 0.08, 0.92, 1],
          ).createShader(r),
          child: ExcludeSemantics(
            child: ListView.builder(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => Center(child: widget.children[i % widget.children.length]),
            ),
          ),
        ),
      );
}

/// Counts from 0 to [value] once it scrolls into view.
class CountUp extends StatelessWidget {
  final int value;
  final String suffix;
  final TextStyle? style;
  const CountUp({super.key, required this.value, this.suffix = "", this.style});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.toDouble()),
        duration: const Duration(milliseconds: 1800),
        curve: Curves.easeOutExpo,
        builder: (_, v, __) => GradientText("${v.round()}$suffix", style: style),
      );
}

/// Pulsing status dot.
class PulseDot extends StatefulWidget {
  final Color color;
  const PulseDot({super.key, this.color = const Color(0xFF3DDC97)});
  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
        ..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 18,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => Stack(alignment: Alignment.center, children: [
            Container(
              width: 8 + 10 * _c.value,
              height: 8 + 10 * _c.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.5 * (1 - _c.value)),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
            ),
          ]),
        ),
      );
}

/// Gentle continuous float (used on hero art and badges).
class Floating extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration period;
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 10,
    this.period = const Duration(seconds: 4),
  });
  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period)..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, math.sin(_c.value * 2 * math.pi) * widget.amplitude),
          child: child,
        ),
      );
}
