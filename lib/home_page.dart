import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/portfolio_data.dart';
import 'github_api.dart';
import 'sections/about.dart';
import 'sections/contact.dart';
import 'sections/hero.dart';
import 'sections/projects.dart';
import 'sections/services.dart';
import 'theme/app_theme.dart';
import 'widgets/backdrop.dart';
import 'widgets/brand_logo.dart';
import 'widgets/common.dart';
import 'widgets/effects.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _labels = ["Home", "About", "Services", "Projects", "Contact"];
  final _keys = List.generate(_labels.length, (_) => GlobalKey());
  final _scroll = ScrollController();
  final _pointer = ValueNotifier<Offset?>(null);
  final _progress = ValueNotifier<double>(0);
  final _active = ValueNotifier<int>(0);
  final _scrolled = ValueNotifier<bool>(false);
  late final Future<void> _reposLoad = context.read<GithubRepos>().getGithubRepos();
  bool _intro = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) setState(() => _intro = false);
    });
  }

  void _onScroll() {
    final pos = _scroll.position;
    _progress.value = pos.maxScrollExtent == 0 ? 0 : (pos.pixels / pos.maxScrollExtent).clamp(0, 1);
    _scrolled.value = pos.pixels > 30;
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

  @override
  void dispose() {
    _scroll.dispose();
    for (final n in [_pointer, _progress, _active, _scrolled]) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: context.isDesktop ? null : _MobileMenu(labels: _labels, active: _active, onTap: _goTo),
      body: MouseRegion(
        onHover: (e) => _pointer.value = e.position,
        onExit: (_) => _pointer.value = null,
        child: Stack(children: [
          Positioned.fill(child: Backdrop(pointer: _pointer)),
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(children: [
                KeyedSubtree(key: _keys[0], child: HeroSection(onViewWork: () => _goTo(3))),
                const _TechBand(),
                KeyedSubtree(key: _keys[1], child: AboutSection(onContact: () => _goTo(4))),
                KeyedSubtree(key: _keys[2], child: const ServicesSection()),
                KeyedSubtree(key: _keys[3], child: ProjectsSection(loading: _reposLoad)),
                KeyedSubtree(key: _keys[4], child: const ContactSection()),
                const _Footer(),
              ]),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _NavBar(labels: _labels, active: _active, scrolled: _scrolled, onTap: _goTo),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (_, v, __) => Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: v,
                  child: Container(height: 3, decoration: const BoxDecoration(gradient: Brand.fire)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (_, v, __) => AnimatedScale(
                scale: v > 0.15 ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: FloatingActionButton.small(
                  tooltip: "Back to top",
                  backgroundColor: Brand.orange,
                  foregroundColor: Colors.white,
                  onPressed: () => _goTo(0),
                  child: const Icon(Icons.arrow_upward_rounded),
                ),
              ),
            ),
          ),
          // Intro: logo draws itself, then the overlay fades away.
          IgnorePointer(
            ignoring: !_intro,
            child: AnimatedOpacity(
              opacity: _intro ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment.center,
                child: const BrandLogo(size: 120, animateIn: true),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final List<String> labels;
  final ValueNotifier<int> active;
  final ValueNotifier<bool> scrolled;
  final ValueChanged<int> onTap;
  const _NavBar({required this.labels, required this.active, required this.scrolled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: scrolled,
      builder: (context, isScrolled, child) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isScrolled ? 18 : 0, sigmaY: isScrolled ? 18 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isScrolled
                  ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7)
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: isScrolled ? context.colors.onSurface.withValues(alpha: 0.06) : Colors.transparent,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: isScrolled ? 12 : 22),
            child: child,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(onTap: () => onTap(0), child: const BrandLockup()),
            ),
            const Spacer(),
            if (context.isDesktop)
              ValueListenableBuilder<int>(
                valueListenable: active,
                builder: (_, a, __) => Row(children: [
                  for (var i = 0; i < labels.length; i++)
                    _NavItem(label: labels[i], selected: a == i, onTap: () => onTap(i)),
                ]),
              ),
            const SizedBox(width: 8),
            const _ThemeToggle(),
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
              decoration: const BoxDecoration(gradient: Brand.fire),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return IconButton(
      tooltip: theme.isDarkMode ? "Light mode" : "Dark mode",
      onPressed: theme.toggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, a) => RotationTransition(
          turns: Tween(begin: 0.5, end: 1.0).animate(a),
          child: FadeTransition(opacity: a, child: child),
        ),
        child: Icon(
          theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(theme.isDarkMode),
          color: Brand.orange,
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
                  from: const Offset(30, 0),
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
                              style: context.text.labelMedium!.copyWith(color: Brand.orange)),
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

class _TechBand extends StatelessWidget {
  const _TechBand();

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: on.withValues(alpha: 0.08))),
        color: on.withValues(alpha: 0.02),
      ),
      child: Semantics(
        label: "Tech stack: ${techStack.join(", ")}",
        child: Marquee(children: [
        for (final t in techStack)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(children: [
              const Text("✦", style: TextStyle(color: Brand.orange)),
              const SizedBox(width: 22),
              Text(t,
                  style: context.text.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: on.withValues(alpha: 0.75),
                  )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final muted = context.text.bodySmall!.copyWith(color: on.withValues(alpha: 0.5));
    return Container(
      margin: const EdgeInsets.only(top: 100),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: on.withValues(alpha: 0.08)))),
      child: Section(
        top: 40,
        bottom: 40,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 24,
          runSpacing: 20,
          children: [
            const BrandLockup(size: 32),
            Text("© ${DateTime.now().year} ${Profile.name} · Designed & built with Flutter", style: muted),
            const SocialRow(),
          ],
        ),
      ),
    );
  }
}
