import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

/// Every shipped app as a card with a mock-up cover built from its real screenshots.
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _all = "All";
  String _filter = _all;

  @override
  Widget build(BuildContext context) {
    final families = [_all, ...{for (final a in apps) a.family}];
    final visible = _filter == _all ? apps : apps.where((a) => a.family == _filter).toList();
    final columns = context.isMobile ? 1 : (context.isDesktop ? 3 : 2);

    return Section(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(
          eyebrow: "Projects",
          title: "Recent apps",
          subtitle: "Every app I've shipped, plus what's in progress.",
        ),
        Reveal(
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            for (final f in families)
              ChoiceChip(
                label: Text(f == _all ? "All (${apps.length})" : f),
                selected: _filter == f,
                showCheckmark: false,
                onSelected: (_) => setState(() => _filter = f),
                selectedColor: context.colors.onSurface,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _filter == f ? context.colors.surface : context.colors.onSurface,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(color: context.colors.onSurface.withValues(alpha: 0.12)),
              ),
          ]),
        ),
        const SizedBox(height: 40),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: CardGrid(
            key: ValueKey(_filter),
            columns: columns,
            children: [
              for (var i = 0; i < visible.length; i++)
                Reveal(
                  flip: true,
                  delay: Duration(milliseconds: 80 * (i % columns)),
                  child: _ProjectCard(visible[i]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Wrap(spacing: 16, runSpacing: 16, children: [
          for (final s in storePages)
            GhostButton(label: s.label, icon: Icons.shop_rounded, onPressed: () => openLink(s.url)),
        ]),
      ]),
    );
  }
}

/// Wraps [y] into the range centred on zero, [span] wide, for endless scrolling.
double wrapCentered(double y, double span) => ((y + span / 2) % span) - span / 2;

/// Whether a screen at [p] on the wall's tilted plane can be seen on a card of size [card].
bool isOnCard(Offset p, Size card, {required double margin}) {
  const angle = -0.58, foreshorten = 0.81; // the plane's Z rotation and the cosine of its X tilt
  final sx = p.dx * math.cos(angle) - p.dy * math.sin(angle);
  final sy = (p.dx * math.sin(angle) + p.dy * math.cos(angle)) * foreshorten;
  return sx.abs() < card.width / 2 + margin && sy.abs() < card.height / 2 + margin;
}

/// A living wall of the app's screens on a tilted plane, with a framed phone at the centre.
/// Assembles on arrival, drifts endlessly, and reacts to the cursor; idle when off screen.
class MockupCover extends StatefulWidget {
  final AppPreview app;
  const MockupCover(this.app, {super.key});

  @override
  State<MockupCover> createState() => _MockupCoverState();
}

class _MockupCoverState extends State<MockupCover> with TickerProviderStateMixin {
  static const _reach = 2, _idleSpeed = 0.09, _hoverSpeed = 0.42, _phoneSeconds = 2.8;
  late final Ticker _ticker = createTicker(_tick);
  late final AnimationController _intro =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  final _frame = ValueNotifier<int>(0);
  final _phones = <int, Widget>{};
  ScrollPosition? _position;
  Duration _last = Duration.zero;
  double _time = 0, _phase = 0, _speed = _idleSpeed, _lift = 0;
  Offset _tilt = Offset.zero, _tiltTarget = Offset.zero;
  bool _hover = false, _still = false, _near = false;
  double? _tilesWidth;
  var _tiles = <(int, int, Widget)>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still = MediaQuery.disableAnimationsOf(context);
    _position?.removeListener(_sync);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_sync);
    if (_still) _intro.value = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  void _sync() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    // Screenshots download only as the card nears the screen, not all at page load.
    if (!_near && top + box.size.height > -viewport && top < viewport * 1.6) setState(() => _near = true);
    if (_still) return;
    final onScreen = top + box.size.height > 0 && top < viewport;
    if (onScreen) {
      if (!_ticker.isActive) {
        _last = Duration.zero;
        _ticker.start();
      }
      if (_intro.isDismissed && top < viewport * 0.8) _intro.forward(); // wait until it's properly in view
    } else if (_ticker.isActive) {
      _ticker.stop();
    }
  }

  void _tick(Duration elapsed) {
    final dt = ((elapsed - _last).inMicroseconds / 1e6).clamp(0.0, 0.1);
    _last = elapsed;
    _time += dt;
    _speed += ((_hover ? _hoverSpeed : _idleSpeed) - _speed) * math.min(1, dt * 5);
    _phase += _speed * dt;
    _lift += ((_hover ? 1 : 0) - _lift) * math.min(1, dt * 9);
    _tilt = Offset.lerp(_tilt, _hover ? _tiltTarget : Offset.zero, math.min(1, dt * 8))!;
    _frame.value++;
  }

  @override
  void dispose() {
    _position?.removeListener(_sync);
    _ticker.dispose();
    _intro.dispose();
    _frame.dispose();
    super.dispose();
  }

  // One decode size for wall and phone: they share a cached image, so the phone is never blank.
  Widget _image(int index, double width) => Image.asset(
        widget.app.shot(index % widget.app.shots),
        width: width,
        height: width * 2.05,
        fit: BoxFit.cover,
        cacheWidth: 360,
        filterQuality: FilterQuality.medium, // mipmaps: small drifting screens don't shimmer
        gaplessPlayback: true,
        excludeFromSemantics: true,
      );

  Widget _flatScreen(int index, double width) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.13),
          boxShadow: [
            // Unblurred on purpose: every screen redraws each frame, and blur is what stuttered.
            BoxShadow(color: Colors.black.withValues(alpha: 0.16), offset: const Offset(-5, 9)),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(width * 0.13), child: _image(index, width)),
      );

  Widget _phone(int index, double width) => _phones.putIfAbsent(
        index,
        () => Container(
          padding: EdgeInsets.all(width * 0.035),
          decoration: BoxDecoration(
            color: const Color(0xFF05090F),
            borderRadius: BorderRadius.circular(width * 0.17),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 26, offset: const Offset(-6, 12)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width * 0.13),
            child: KeyedSubtree(key: ValueKey(index), child: _image(index, width)),
          ),
        ),
      );

  void _buildTiles(double s, double gap) {
    _tiles = [
      for (var col = -_reach; col <= _reach; col++)
        for (var row = -_reach; row <= _reach; row++)
          (col, row, _flatScreen(col + _reach + (row + _reach) * 2, s)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final tint = Color(app.tint);
    return Semantics(
      image: true,
      label: "${app.name} app screens",
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.lerp(tint, Colors.white, 0.28)!, tint],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: MouseRegion(
              opaque: false,
              onEnter: (_) => _hover = true,
              onExit: (_) => _hover = false,
              onHover: (e) {
                final size = (context.findRenderObject() as RenderBox).size;
                _tiltTarget = Offset(e.localPosition.dx / size.width * 2 - 1, e.localPosition.dy / size.height * 2 - 1);
              },
              child: LayoutBuilder(builder: (context, c) {
                if (!_near) return const SizedBox.expand();
                final w = c.maxWidth;
                final s = w * 0.22;
                final h = s * 2.05;
                final gap = s * 0.18;
                if (_tilesWidth != w) {
                  _tilesWidth = w;
                  _phones.clear();
                  _buildTiles(s, gap);
                }
                final rowHeight = h + gap;
                final span = (_reach * 2 + 1) * rowHeight;
                return ClipRect(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_intro, _frame]),
                    builder: (_, __) {
                      final phoneIndex = app.shots == 1 ? 0 : (_time / _phoneSeconds).floor() % app.shots;
                      final pop = const Interval(0.32, 1, curve: Curves.easeOutBack).transform(_intro.value);
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0008)
                          ..rotateX(0.62 - _tilt.dy * 0.1)
                          ..rotateY(_tilt.dx * 0.1)
                          ..rotateZ(-0.58),
                        child: Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
                          for (final (col, row, tile) in _tiles)
                            if (_placed(col, row, tile, Size(w, c.maxHeight), s, gap, rowHeight, span) case final placed?)
                              placed,
                          Transform.translate(
                            offset: Offset(0, math.sin(_time * 1.3) * s * 0.03),
                            child: Transform.scale(
                              scale: pop * (1 + 0.09 * _lift),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: _phone(phoneIndex, s * 1.45),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _placed(int col, int row, Widget tile, Size card, double s, double gap, double rowHeight, double span) {
    // Screens nearest the centre arrive first; neighbouring columns drift in opposite directions.
    final delay = (col.abs() + row.abs()) / (_reach * 2) * 0.45;
    final t = Interval(delay, delay + 0.55, curve: Curves.easeOutCubic).transform(_intro.value);
    final y = wrapCentered(
      row * rowHeight + (col.isOdd ? rowHeight / 2 : 0) + (col.isEven ? -1 : 1) * _phase * rowHeight,
      span,
    );
    final x = col * (s + gap);
    if (!isOnCard(Offset(x, y), card, margin: s * 1.6)) return null;
    return Transform.translate(
      key: ValueKey(col * 100 + row), // stays matched to its screen as others enter and leave
      offset: Offset(x * t, y * t),
      child: Transform.scale(scale: 0.6 + 0.4 * t, child: Opacity(opacity: t, child: tile)),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final AppPreview app;
  const _ProjectCard(this.app);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Semantics(
      button: true,
      label: "${app.name}: open details",
      child: HoverLift(
        onTap: () => showAppDetail(context, app),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(aspectRatio: 4 / 4, child: MockupCover(app)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 66,
                  child: Text(
                    app.blurb,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium!.copyWith(height: 1.6, color: on.withValues(alpha: 0.65)),
                  ),
                ),
                const SizedBox(height: 18),
                _MetaRow(app),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final AppPreview app;
  final bool hint;
  const _MetaRow(this.app, {this.hint = true});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Brand.copper),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(app.storeUrl == null ? "In development" : app.category,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelMedium),
        ),
        if (hint) ...[
          Text("Details", style: context.text.labelMedium!.copyWith(color: context.accentText)),
          const SizedBox(width: 4),
          Icon(Icons.north_east_rounded, size: 16, color: context.accentText),
        ],
      ]);
}

/// Detail sheet that grows out of the widget that opened it.
Future<void> showAppDetail(BuildContext context, AppPreview app) {
  final box = context.findRenderObject() as RenderBox?;
  final screen = MediaQuery.sizeOf(context);
  final from = box == null ? screen.center(Offset.zero) : box.localToGlobal(box.size.center(Offset.zero));
  final origin = Alignment(from.dx / screen.width * 2 - 1, from.dy / screen.height * 2 - 1);
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 460),
      transitionBuilder: (_, a, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: const Interval(0, 0.5)),
        child: ScaleTransition(
          alignment: origin,
          scale: Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOutQuint)),
          child: child,
        ),
      ),
      pageBuilder: (context, _, __) => _AppDetail(app),
    );
}

class _AppDetail extends StatelessWidget {
  final AppPreview app;
  const _AppDetail(this.app);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 12 : 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  SizedBox(
                    width: double.infinity,
                    // Tall like the cards, but always leaving room for the text on short screens.
                    height: math.min(
                      math.min(820.0, MediaQuery.sizeOf(context).width) * 0.75,
                      MediaQuery.sizeOf(context).height * 0.78,
                    ),
                    child: MockupCover(app),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: IconButton.filled(
                      tooltip: "Close",
                      style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.5)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.all(context.isMobile ? 22 : 36),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (final (i, part) in <Widget>[
                    Text(app.name, style: context.text.headlineMedium!.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),
                    Text(app.blurb,
                        style: context.text.bodyLarge!.copyWith(height: 1.75, color: on.withValues(alpha: 0.75))),
                    const SizedBox(height: 20),
                    _MetaRow(app, hint: false),
                    const SizedBox(height: 16),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final t in app.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: on.withValues(alpha: 0.06)),
                          child: Text(t, style: context.text.labelMedium),
                        ),
                    ]),
                    if (app.storeUrl != null) ...[
                      const SizedBox(height: 28),
                      PrimaryButton(label: "View on Google Play", onPressed: () => openLink(app.storeUrl!)),
                    ],
                    ].indexed)
                      StaggerIn(index: i, child: part),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
