import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

/// First-page app gallery: a stage with real store screenshots and a dock of app icons.
class ShowcaseSection extends StatefulWidget {
  const ShowcaseSection({super.key});

  @override
  State<ShowcaseSection> createState() => _ShowcaseSectionState();
}

class _ShowcaseSectionState extends State<ShowcaseSection> {
  int _index = 0;
  bool _hovering = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _timer = Timer.periodic(const Duration(seconds: 6), (_) {
        if (!_hovering) setState(() => _index = (_index + 1) % apps.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final app = apps[_index];
    final live = apps.where((a) => a.playId != null).length;
    final info = AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topLeft,
        children: [...previous, if (current != null) current],
      ),
      child: _AppInfo(app, key: ValueKey(app.slug)),
    );
    final stage = SizedBox(
      height: desktop ? 500 : 420,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 460),
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (child, a) => FadeTransition(
          opacity: a,
          child: ScaleTransition(scale: Tween(begin: 0.95, end: 1.0).animate(a), child: child),
        ),
        child: _PhoneFan(app, key: ValueKey(app.slug)),
      ),
    );

    return Section(
      top: 72,
      child: MouseRegion(
        onEnter: (_) => _hovering = true,
        onExit: (_) => _hovering = false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(
            eyebrow: "App gallery",
            title: "$live apps live on Google Play",
            subtitle: "Real store screenshots from apps I built and shipped, plus what's in progress.",
          ),
          Reveal(
            child: desktop
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 5, child: SizedBox(height: 340, child: info)),
                    const SizedBox(width: 40),
                    Expanded(flex: 7, child: stage),
                  ])
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    stage,
                    const SizedBox(height: 24),
                    SizedBox(height: 300, child: info),
                  ]),
          ),
          const SizedBox(height: 28),
          Reveal(child: desktop ? _Dock(selected: _index, onSelect: _select) : _IconRail(selected: _index, onSelect: _select)),
        ]),
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  final AppPreview app;
  const _AppInfo(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final live = app.storeUrl != null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(children: [
        _AppIcon(app, size: 64),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(app.category.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelSmall!.copyWith(
                  color: context.accentText,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            Text(app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.headlineSmall!.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5)),
          ]),
        ),
      ]),
      const SizedBox(height: 18),
      Text(app.blurb,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodyLarge!.copyWith(fontSize: 17, height: 1.55, color: on.withValues(alpha: 0.75))),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final t in app.tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: on.withValues(alpha: 0.06)),
            child: Text(t, style: context.text.labelMedium),
          ),
      ]),
      const SizedBox(height: 22),
      if (live)
        PrimaryButton(label: "View on Google Play", onPressed: () => openLink(app.storeUrl!))
      else
        Row(children: [
          Icon(Icons.construction_rounded, size: 16, color: context.accentText),
          const SizedBox(width: 8),
          Text("In development", style: context.text.titleSmall!.copyWith(color: context.accentText)),
        ]),
    ]);
  }
}

class _AppIcon extends StatelessWidget {
  final AppPreview app;
  final double size;
  const _AppIcon(this.app, {required this.size});

  @override
  Widget build(BuildContext context) => Container(
        // Several icons are white, so they need an edge on a white page.
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.23),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(size * 0.23)),
        child: Image.asset(app.icon, width: size, height: size, fit: BoxFit.cover, excludeFromSemantics: true),
      );
}

/// Up to three phones fanned out, showing the app's store screenshots.
class _PhoneFan extends StatelessWidget {
  final AppPreview app;
  const _PhoneFan(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    if (app.shots == 0) {
      return Center(child: _MiniPhone(width: 214, child: _IconScreen(app)));
    }
    final spread = context.isMobile ? 78.0 : 142.0;
    final side = context.isMobile ? 132.0 : 176.0;
    final front = context.isMobile ? 172.0 : 224.0;
    // With only two screenshots, shift the pair so it stays centred.
    final shift = app.shots == 2 ? spread * 0.35 : 0.0;
    Widget phone(int i, double width) => _MiniPhone(
          width: width,
          child: Image.asset(
            app.shot(i),
            fit: BoxFit.cover,
            semanticLabel: "${app.name} screenshot ${i + 1}",
          ),
        );
    return Stack(alignment: Alignment.center, children: [
      if (app.shots > 1)
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(-spread - shift, 20, 0, 1)
            ..rotateZ(-0.09),
          child: phone(1, side),
        ),
      if (app.shots > 2)
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(spread, 20, 0, 1)
            ..rotateZ(0.09),
          child: phone(2, side),
        ),
      Transform.translate(offset: Offset(shift, 0), child: phone(0, front)),
    ]);
  }
}

class _IconScreen extends StatelessWidget {
  final AppPreview app;
  const _IconScreen(this.app);

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFF0E1A29),
        child: Center(child: _AppIcon(app, size: 104)),
      );
}

class _MiniPhone extends StatelessWidget {
  final double width;
  final Widget child;
  const _MiniPhone({required this.width, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: width * 2.04,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFF05090F),
          borderRadius: BorderRadius.circular(width * 0.16),
          border: Border.all(color: const Color(0xFF34465C), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.32), blurRadius: 34, offset: const Offset(0, 18)),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(width * 0.13), child: SizedBox.expand(child: child)),
      );
}

/// macOS-style dock: icons swell as the cursor approaches.
class _Dock extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _Dock({required this.selected, required this.onSelect});

  @override
  State<_Dock> createState() => _DockState();
}

class _DockState extends State<_Dock> {
  static const _gap = 10.0, _reach = 100.0, _grow = 0.7;
  double? _pointer;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final n = apps.length;
        // The extra 2.2 icon widths leave room for the swell, so the row never overflows the dock.
        final base = math.min(60.0, (c.maxWidth - _gap * (n - 1)) / (n + 2.2));
        final startX = (c.maxWidth - (n * base + (n - 1) * _gap)) / 2;
        double scaleOf(int i) {
          if (_pointer == null || MediaQuery.disableAnimationsOf(context)) return 1;
          final d = _pointer! - (startX + i * (base + _gap) + base / 2);
          return 1 + _grow * math.exp(-(d * d) / (_reach * _reach));
        }

        return MouseRegion(
          onHover: (e) => setState(() => _pointer = e.localPosition.dx),
          onExit: (_) => setState(() => _pointer = null),
          child: SizedBox(
            height: base * (1 + _grow) + 26,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Container(
                height: base + 22,
                decoration: BoxDecoration(
                  color: context.colors.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
              ),
              Positioned(
                bottom: 13,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  for (var i = 0; i < n; i++)
                    Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : _gap),
                      child: _DockIcon(apps[i], size: base * scaleOf(i), active: i == widget.selected, onTap: () => widget.onSelect(i)),
                    ),
                ]),
              ),
            ]),
          ),
        );
      });
}

class _DockIcon extends StatelessWidget {
  final AppPreview app;
  final double size;
  final bool active;
  final VoidCallback onTap;
  const _DockIcon(this.app, {required this.size, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: active,
        label: app.name,
        child: Tooltip(
          message: app.name,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(size * 0.23),
            child: Stack(clipBehavior: Clip.none, alignment: Alignment.bottomCenter, children: [
              _AppIcon(app, size: size),
              if (active)
                Positioned(
                  bottom: -9,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(color: Brand.copper, shape: BoxShape.circle),
                  ),
                ),
            ]),
          ),
        ),
      );
}

/// Touch version of the dock: a swipeable row of icons.
class _IconRail extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _IconRail({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 76,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 6),
          itemCount: apps.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => _DockIcon(apps[i], size: 56, active: i == selected, onTap: () => onSelect(i)),
        ),
      );
}
