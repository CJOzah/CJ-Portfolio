import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/portfolio_data.dart';
import 'sections/about.dart';
import 'sections/contact.dart';
import 'sections/experience.dart';
import 'sections/hero.dart';
import 'sections/projects.dart';
import 'sections/services.dart';
import 'sections/showcase.dart';
import 'sections/work.dart';
import 'theme/app_theme.dart';
import 'widgets/brand_logo.dart';
import 'widgets/command_palette.dart';
import 'widgets/common.dart';
import 'widgets/effects.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const _labels = ["Home", "Work", "About", "Experience", "Services", "Contact"];
  static const _icons = [
    Icons.home_outlined,
    Icons.apps_rounded,
    Icons.person_outline_rounded,
    Icons.work_outline_rounded,
    Icons.design_services_outlined,
    Icons.mail_outline_rounded,
  ];
  final _keys = List.generate(_labels.length, (_) => GlobalKey());
  final _scroll = ScrollController();
  final _active = ValueNotifier<int>(0);
  final _pageKey = GlobalKey();
  late final AnimationController _themeWipe =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 720));
  ui.Image? _oldTheme;
  Offset _wipeOrigin = Offset.zero;
  final _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scroll.position;
    _progress.value = pos.maxScrollExtent == 0 ? 0 : (pos.pixels / pos.maxScrollExtent).clamp(0.0, 1.0);
    // Scroll spy: last section whose top has passed 40% of the viewport.
    final probe = MediaQuery.sizeOf(context).height * 0.4;
    var active = 0;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.localToGlobal(Offset.zero).dy <= probe) active = i;
    }
    if (pos.pixels >= pos.maxScrollExtent - 4) active = _keys.length - 1;
    _active.value = active;
  }

  void _goTo(int i) {
    final ctx = _keys[i].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 900), curve: Curves.easeInOutCubic);
  }

  /// Switches theme by wiping a circle of the new look out from [origin].
  Future<void> _toggleTheme(Offset origin) async {
    final theme = context.read<ThemeProvider>();
    if (_oldTheme != null) return; // a wipe is already running
    ui.Image? shot;
    if (!MediaQuery.disableAnimationsOf(context)) {
      try {
        final boundary = _pageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        shot = await boundary.toImage(pixelRatio: MediaQuery.devicePixelRatioOf(context));
      } catch (_) {
        // No snapshot available: the theme still changes, just without the wipe.
      }
    }
    if (!mounted) return;
    if (shot == null) return theme.toggle();
    setState(() {
      _oldTheme = shot;
      _wipeOrigin = origin;
    });
    theme.toggle();
    await _themeWipe.forward(from: 0);
    if (!mounted) return;
    _oldTheme?.dispose();
    setState(() => _oldTheme = null);
  }

  void _openPalette() {
    final theme = context.read<ThemeProvider>();
    final messenger = ScaffoldMessenger.of(context);
    showCommandPalette(context, [
      for (var i = 0; i < _labels.length; i++)
        PaletteItem("Go to ${_labels[i]}", "Section", _icons[i], () => _goTo(i)),
      for (final a in apps)
        PaletteItem(a.name, a.category, Icons.smartphone_rounded, () => showAppDetail(context, a)),
      for (final r in experience)
        PaletteItem("${r.title} @ ${r.company}", "Experience", Icons.work_outline_rounded, () => _goTo(3)),
      PaletteItem(
          "Download CV", "Action", Icons.download_rounded, () => openLink("assets/${Profile.cvAsset}")),
      PaletteItem("Copy email address", "Action", Icons.copy_rounded, () {
        Clipboard.setData(const ClipboardData(text: Profile.email));
        messenger.showSnackBar(const SnackBar(content: Text("Copied ${Profile.email}")));
      }),
      PaletteItem(
          "Email me", "Action", Icons.mail_outline_rounded, () => openLink("mailto:${Profile.email}")),
      PaletteItem("Chat on WhatsApp", "Action", Icons.chat_outlined,
          () => openLink("https://wa.me/${Profile.whatsapp}")),
      PaletteItem(theme.isDarkMode ? "Switch to light mode" : "Switch to dark mode", "Action",
          theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          () => _toggleTheme(Offset(MediaQuery.sizeOf(context).width - 80, 36))),
      for (final s in socials)
        PaletteItem("Open ${s.label}", "Social", Icons.open_in_new_rounded, () => openLink(s.url)),
      for (final s in storePages)
        PaletteItem(s.label, "Google Play", Icons.shop_rounded, () => openLink(s.url)),
    ]);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _active.dispose();
    _themeWipe.dispose();
    _oldTheme?.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget band(Widget child) => ColoredBox(
          color: context.bandColor,
          child: SizedBox(width: double.infinity, child: child),
        );
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _openPalette,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          endDrawer: context.isDesktop ? null : _MobileMenu(labels: _labels, active: _active, onTap: _goTo),
          body: Stack(children: [
            RepaintBoundary(key: _pageKey, child: Stack(children: [
            SelectionArea(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(children: [
                  KeyedSubtree(key: _keys[0], child: HeroSection(onViewWork: () => _goTo(1))),
                  KeyedSubtree(
                    key: _keys[1],
                    child: Column(children: [const ShowcaseSection(), band(const WorkSection())]),
                  ),
                  const ProjectsSection(),
                  KeyedSubtree(key: _keys[2], child: band(AboutSection(onContact: () => _goTo(5)))),
                  KeyedSubtree(key: _keys[3], child: const ExperienceSection()),
                  KeyedSubtree(key: _keys[4], child: band(const ServicesSection())),
                  KeyedSubtree(key: _keys[5], child: const ContactSection()),
                  const _Footer(),
                ]),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _DropIn(
                child: _NavBar(
                  labels: _labels,
                  active: _active,
                  progress: _progress,
                  onTap: _goTo,
                  onSearch: _openPalette,
                  onToggleTheme: _toggleTheme,
                ),
              ),
            ),
            ])),
            if (_oldTheme != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _themeWipe,
                    builder: (_, __) => ClipPath(
                      clipper: _WipeClipper(_wipeOrigin, Curves.easeInOutCubic.transform(_themeWipe.value)),
                      child: RawImage(image: _oldTheme, fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final List<String> labels;
  final ValueNotifier<int> active;
  final ValueNotifier<double> progress;
  final ValueChanged<int> onTap;
  final VoidCallback onSearch;
  final ValueChanged<Offset> onToggleTheme;
  const _NavBar({
    required this.labels,
    required this.active,
    required this.progress,
    required this.onTap,
    required this.onSearch,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) => Stack(alignment: Alignment.bottomLeft, children: [
        _bar(context),
        ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (_, v, __) => FractionallySizedBox(
            widthFactor: v,
            child: Container(height: 2, color: Brand.copper),
          ),
        ),
      ]);

  Widget _bar(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(onTap: () => onTap(0), child: const BrandLockup(drawIn: true)),
              ),
              const Spacer(),
              if (context.isDesktop)
                ValueListenableBuilder<int>(
                  valueListenable: active,
                  builder: (_, a, __) => Row(children: [
                    // Home is the logo.
                    for (var i = 1; i < labels.length; i++)
                      _NavItem(label: labels[i], selected: a == i, onTap: () => onTap(i)),
                  ]),
                ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: "Quick search (⌘K)",
                onPressed: onSearch,
                icon: const Icon(Icons.search_rounded, size: 20),
              ),
              _ThemeToggle(onToggle: onToggleTheme),
              if (!context.isDesktop)
                Builder(
                  builder: (ctx) => IconButton(
                    tooltip: "Menu",
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                ),
            ]),
          ),
        ),
      );
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.selected, required this.onTap});
  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final lit = widget.selected || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: context.text.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: lit ? context.colors.onSurface : context.colors.onSurface.withValues(alpha: 0.55),
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 2,
              width: widget.selected ? 22 : (_hover ? 10 : 0),
              color: Brand.copper,
            ),
          ]),
        ),
      ),
    );
  }
}

/// Slides its child down from above the screen on first load.
class _DropIn extends StatelessWidget {
  final Widget child;
  const _DropIn({required this.child});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: MediaQuery.disableAnimationsOf(context) ? 0 : -1, end: 0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutQuint,
        child: child,
        builder: (_, y, child) => FractionalTranslation(translation: Offset(0, y), child: child),
      );
}

/// Keeps everything outside a growing circle, so the old theme is wiped away.
class _WipeClipper extends CustomClipper<Path> {
  final Offset origin;
  final double t;
  _WipeClipper(this.origin, this.t);

  @override
  Path getClip(Size size) => Path()
    ..fillType = PathFillType.evenOdd
    ..addRect(Offset.zero & size)
    ..addOval(Rect.fromCircle(center: origin, radius: size.longestSide * 1.25 * t));

  @override
  bool shouldReclip(_WipeClipper old) => old.t != t || old.origin != origin;
}

class _ThemeToggle extends StatelessWidget {
  final ValueChanged<Offset> onToggle;
  const _ThemeToggle({required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return IconButton(
      tooltip: theme.isDarkMode ? "Light mode" : "Dark mode",
      onPressed: () {
        final box = context.findRenderObject() as RenderBox;
        onToggle(box.localToGlobal(box.size.center(Offset.zero)));
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, a) => RotationTransition(
          turns: Tween(begin: 0.5, end: 1.0).animate(a),
          child: FadeTransition(opacity: a, child: child),
        ),
        child: Icon(
          theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(theme.isDarkMode),
          size: 20,
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final List<String> labels;
  final ValueNotifier<int> active;
  final ValueChanged<int> onTap;
  const _MobileMenu({required this.labels, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BrandLockup(),
              const SizedBox(height: 48),
              for (var i = 0; i < labels.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 60 * i),
                  child: ValueListenableBuilder<int>(
                    valueListenable: active,
                    builder: (_, a, __) => InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onTap(i);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(children: [
                          Text("0${i + 1}",
                              style: context.text.labelMedium!.copyWith(color: context.accentText)),
                          const SizedBox(width: 16),
                          Text(
                            labels[i],
                            style: context.text.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: a == i ? null : context.colors.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              const SocialRow(),
            ]),
          ),
        ),
      );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => Theme(
        data: AppTheme.dark,
        child: Builder(
          builder: (context) => ColoredBox(
            color: Brand.navy,
            child: SizedBox(
              width: double.infinity,
              child: Section(
                top: 40,
                bottom: 40,
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      const BrandLockup(),
                      Text(
                        "© ${DateTime.now().year} ${Profile.name}. All rights reserved.",
                        style: context.text.bodySmall!.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                      const SocialRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
