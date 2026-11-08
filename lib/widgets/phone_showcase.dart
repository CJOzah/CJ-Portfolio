import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const _demos = [
  ("Dreacot", "Live tracking"),
  ("EventPadi", "QR check-in"),
  ("Omniverse", "Live polling"),
];

// In-phone palette: the device stays dark in both site themes.
const _screenBg = Color(0xFF0E1A29);
const _card = Color(0xFF182A3E);
const _muted = Color(0xB3FFFFFF);
const _green = Color(0xFF3DD68C);

/// A phone running concept screens of shipped features, built as real Flutter UI.
/// Cycles on its own, tilts toward the cursor, and pauses when scrolled away.
class PhoneShowcase extends StatefulWidget {
  final double width;
  const PhoneShowcase({super.key, this.width = 270});

  @override
  State<PhoneShowcase> createState() => _PhoneShowcaseState();
}

class _PhoneShowcaseState extends State<PhoneShowcase> with SingleTickerProviderStateMixin {
  // Where a demo rests when motion is off: its finished state.
  static const _restAt = 0.8;
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 18));
  ScrollPosition? _position;
  bool _still = false;
  Offset _tilt = Offset.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still = MediaQuery.disableAnimationsOf(context);
    _position?.removeListener(_sync);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_sync);
    if (_still) {
      _c.stop();
      _c.value = _restAt / _demos.length;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
    }
  }

  void _sync() {
    if (!mounted || _still) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final onScreen = box.localToGlobal(Offset.zero).dy + box.size.height > 0;
    if (onScreen && !_c.isAnimating) _c.repeat();
    if (!onScreen && _c.isAnimating) _c.stop();
  }

  void _select(int i) {
    _c.value = (i + (_still ? _restAt : 0)) / _demos.length;
    if (!_still) _c.repeat();
  }

  @override
  void dispose() {
    _position?.removeListener(_sync);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final position = _c.value * _demos.length;
          final index = position.floor().clamp(0, _demos.length - 1);
          final t = (position - index).clamp(0.0, 1.0);
          return Column(mainAxisSize: MainAxisSize.min, children: [
            _device(index, t),
            const SizedBox(height: 28),
            SizedBox(
              width: widget.width + 90,
              child: Row(children: [
                for (var i = 0; i < _demos.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
                      child: _Tab(_demos[i], progress: i == index ? t : 0, active: i == index, onTap: () => _select(i)),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            Text("Concept screens based on features I shipped",
                style: context.text.labelSmall!.copyWith(color: context.colors.onSurface.withValues(alpha: 0.55))),
          ]);
        },
      );

  Widget _device(int index, double t) => MouseRegion(
        onHover: (e) {
          final size = (context.findRenderObject() as RenderBox).size;
          setState(() => _tilt = Offset(e.localPosition.dx / size.width * 2 - 1, e.localPosition.dy / size.height * 2 - 1));
        },
        onExit: (_) => setState(() => _tilt = Offset.zero),
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(end: _still ? Offset.zero : _tilt),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          builder: (_, o, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0011)
              ..rotateX(-o.dy * 0.10)
              ..rotateY(-0.16 + o.dx * 0.14),
            child: child,
          ),
          child: RepaintBoundary(
            child: Semantics(
              image: true,
              label: "Concept app screens showing live delivery tracking, QR ticket check-in and live polling",
              child: ExcludeSemantics(child: _frame(index, t)),
            ),
          ),
        ),
      );

  Widget _frame(int index, double t) => Container(
        width: widget.width,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFF05090F),
          borderRadius: BorderRadius.circular(46),
          border: Border.all(color: const Color(0xFF34465C), width: 1.5),
          boxShadow: [
            BoxShadow(color: Brand.copper.withValues(alpha: 0.26), blurRadius: 130, spreadRadius: 6),
            BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 50, offset: const Offset(0, 34)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(37),
          // Laid out at one fixed size, then scaled, so the UI is identical on every screen.
          child: FittedBox(
            child: SizedBox(
              width: 270,
              height: 556,
              child: ColoredBox(
                color: _screenBg,
                child: Stack(children: [
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 420),
                      child: KeyedSubtree(key: ValueKey(index), child: [_TrackingScreen(t), _TicketScreen(t), _PollScreen(t)][index]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 84,
                      height: 24,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

class _Tab extends StatelessWidget {
  final (String, String) demo;
  final double progress;
  final bool active;
  final VoidCallback onTap;
  const _Tab(this.demo, {required this.progress, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(height: 2, color: on.withValues(alpha: 0.14)),
            FractionallySizedBox(widthFactor: progress, child: Container(height: 2, color: Brand.copper)),
          ]),
          const SizedBox(height: 10),
          Text(demo.$1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: active ? on : on.withValues(alpha: 0.6),
              )),
          Text(demo.$2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall!.copyWith(color: on.withValues(alpha: 0.55))),
        ]),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final String title, subtitle;
  const _AppBar(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
        ]),
      );
}

/// Bottom navigation of the in-phone app.
class _TabBar extends StatelessWidget {
  final IconData active;
  const _TabBar(this.active);

  static const _icons = [
    Icons.home_rounded,
    Icons.confirmation_number_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(28, 14, 28, 22),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (final i in _icons)
            Icon(i, size: 22, color: i == active ? Brand.copper : Colors.white.withValues(alpha: 0.35)),
        ]),
      );
}

class _TrackingScreen extends StatelessWidget {
  final double t;
  const _TrackingScreen(this.t);

  @override
  Widget build(BuildContext context) {
    final p = Curves.easeInOutSine.transform((t / 0.92).clamp(0.0, 1.0));
    return Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _MapPainter(p, t))),
      const Align(alignment: Alignment.topLeft, child: _AppBar("On the way", "Order tracking")),
      Positioned(
        left: 12,
        right: 12,
        bottom: 12,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(22)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(color: Brand.copper, shape: BoxShape.circle),
                child: const Icon(Icons.two_wheeler_rounded, color: Brand.ink, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p >= 1 ? "Your rider has arrived" : "Arriving in ${(7 * (1 - p)).ceil()} min",
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  const Text("Rider assigned nearby", style: TextStyle(color: _muted, fontSize: 12)),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: p,
                minHeight: 5,
                color: Brand.copper,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _MapPainter extends CustomPainter {
  final double progress, pulse;
  _MapPainter(this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size s) {
    final road = Paint()
      ..color = const Color(0xFF1B2E44)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final lane = Paint()
      ..color = const Color(0xFF16263A)
      ..strokeWidth = 5;
    for (final y in [0.3, 0.5, 0.68]) {
      canvas.drawLine(Offset(-10, s.height * (y - 0.06)), Offset(s.width + 10, s.height * (y + 0.05)), road);
    }
    for (final x in [0.22, 0.56, 0.84]) {
      canvas.drawLine(Offset(s.width * x, 0), Offset(s.width * (x - 0.12), s.height), lane);
    }
    final route = Path()
      ..moveTo(s.width * 0.16, s.height * 0.68)
      ..cubicTo(s.width * 0.42, s.height * 0.64, s.width * 0.3, s.height * 0.46, s.width * 0.56, s.height * 0.42)
      ..cubicTo(s.width * 0.78, s.height * 0.38, s.width * 0.66, s.height * 0.3, s.width * 0.82, s.height * 0.27);
    final metric = route.computeMetrics().first;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
    canvas.drawPath(route, line..color = Colors.white.withValues(alpha: 0.18));
    canvas.drawPath(metric.extractPath(0, metric.length * progress), line..color = Brand.copper);
    final end = metric.getTangentForOffset(metric.length)!.position;
    canvas.drawCircle(end, 9, Paint()..color = Colors.white);
    canvas.drawCircle(end, 4, Paint()..color = _screenBg);
    final rider = metric.getTangentForOffset(metric.length * progress)!.position;
    final beat = (math.sin(pulse * math.pi * 10) + 1) / 2;
    canvas.drawCircle(rider, 12 + 10 * beat, Paint()..color = Brand.copper.withValues(alpha: 0.32 * (1 - beat)));
    canvas.drawCircle(rider, 8, Paint()..color = Brand.copper);
    canvas.drawCircle(rider, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.progress != progress || old.pulse != pulse;
}

class _TicketScreen extends StatelessWidget {
  final double t;
  const _TicketScreen(this.t);

  static const _scanEnd = 0.6;

  @override
  Widget build(BuildContext context) {
    final verified = ((t - _scanEnd) / 0.08).clamp(0.0, 1.0);
    final done = verified > 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AppBar("Summit Day Pass", "Your ticket"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(children: [
            SizedBox.square(
              dimension: 186,
              child: Stack(children: [
                const Positioned.fill(child: CustomPaint(painter: _QrPainter())),
                if (!done)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 186 * (t / _scanEnd) - 2,
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Brand.copper,
                        boxShadow: [BoxShadow(color: Brand.copper, blurRadius: 12)],
                      ),
                    ),
                  ),
                if (done)
                  Center(
                    child: Transform.scale(
                      scale: Curves.easeOutBack.transform(verified),
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(color: Color(0xFF12A15E), shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 18),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _Field("GATE", "B"),
              _Field("ENTRY", "09:00"),
              _Field("TYPE", "Day pass"),
            ]),
          ]),
        ),
      ),
      const SizedBox(height: 18),
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(30)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(done ? Icons.verified_rounded : Icons.qr_code_scanner_rounded, size: 17, color: done ? _green : _muted),
            const SizedBox(width: 8),
            Text(done ? "Verified. Welcome in" : "Scanning ticket",
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
      const Spacer(),
      const _TabBar(Icons.confirmation_number_rounded),
    ]);
  }
}

class _Field extends StatelessWidget {
  final String label, value;
  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Color(0xFF6B7785), fontSize: 9.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Brand.text, fontSize: 13, fontWeight: FontWeight.w700)),
      ]);
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  static const _n = 25;

  @override
  void paint(Canvas canvas, Size s) {
    final cell = s.width / _n;
    final ink = Paint()..color = Brand.text;
    final rand = math.Random(11); // fixed seed: the pattern must not flicker between frames
    bool finder(int x, int y) => (x < 8 && y < 8) || (x > 16 && y < 8) || (x < 8 && y > 16);
    for (var x = 0; x < _n; x++) {
      for (var y = 0; y < _n; y++) {
        if (rand.nextBool() && !finder(x, y)) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell + 0.4, cell + 0.4), ink);
        }
      }
    }
    for (final o in [Offset.zero, Offset(18 * cell, 0), Offset(0, 18 * cell)]) {
      canvas.drawRect(o & Size.square(7 * cell), ink);
      canvas.drawRect((o + Offset(cell, cell)) & Size.square(5 * cell), Paint()..color = Colors.white);
      canvas.drawRect((o + Offset(2 * cell, 2 * cell)) & Size.square(3 * cell), ink);
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => false;
}

class _PollScreen extends StatelessWidget {
  final double t;
  const _PollScreen(this.t);

  static const _options = [("Real-time Q&A", 0.46), ("Networking", 0.31), ("Workshops", 0.23)];

  @override
  Widget build(BuildContext context) {
    final grow = Curves.easeOutCubic.transform((t / 0.7).clamp(0.0, 1.0));
    final beat = (math.sin(t * math.pi * 10) + 1) / 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AppBar("Main Stage", "Live session"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(22)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF5A5F).withValues(alpha: 0.45 + 0.55 * beat),
                ),
              ),
              const SizedBox(width: 6),
              const Text("LIVE POLL", style: TextStyle(color: _muted, fontSize: 10.5, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text("${1204 + (380 * grow).round()} votes", style: const TextStyle(color: _muted, fontSize: 11)),
            ]),
            const SizedBox(height: 12),
            const Text("What should we cover next?",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            for (final (name, share) in _options) ...[
              Row(children: [
                Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 12.5))),
                Text("${(share * grow * 100).round()}%",
                    style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: share * grow,
                  minHeight: 7,
                  color: Brand.copper,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            const Icon(Icons.forum_outlined, color: Brand.copper, size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text("How do you handle thousands of live users?",
                  style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.35)),
            ),
            const SizedBox(width: 10),
            Text("${38 + (54 * grow).round()}",
                style: const TextStyle(color: Brand.copper, fontSize: 13, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
      const Spacer(),
      const _TabBar(Icons.bar_chart_rounded),
    ]);
  }
}
