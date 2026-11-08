import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;
  const HeroSection({super.key, required this.onViewWork});

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    final desktop = context.isDesktop;
    final copy = _HeroCopy(onViewWork: onViewWork, center: !desktop);
    const art = _HeroArt();

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      child: Section(
        top: mobile ? 110 : 140,
        bottom: 40,
        child: Column(
          children: [
            desktop
                ? Row(children: [
                    Expanded(flex: 11, child: copy),
                    const SizedBox(width: 48),
                    const Expanded(flex: 10, child: art),
                  ])
                : Column(children: [copy, const SizedBox(height: 56), art]),
            const SizedBox(height: 48),
            if (!mobile) const _ScrollCue(),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final VoidCallback onViewWork;
  final bool center;
  const _HeroCopy({required this.onViewWork, required this.center});

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    final on = context.colors.onSurface;
    final nameStyle = (mobile ? context.text.displaySmall : context.text.displayLarge)!.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: mobile ? -1 : -3,
      height: 1.0,
    );
    final cross = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final align = center ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 16, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: on.withValues(alpha: 0.12)),
              color: on.withValues(alpha: 0.04),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const PulseDot(),
              const SizedBox(width: 8),
              Text("Available for new projects",
                  style: context.text.labelLarge!.copyWith(color: on.withValues(alpha: 0.8))),
            ]),
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 100),
          child: Text("Hi, I'm",
              style: context.text.headlineSmall!.copyWith(color: on.withValues(alpha: 0.7))),
        ),
        const SizedBox(height: 8),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: Wrap(
            alignment: center ? WrapAlignment.center : WrapAlignment.start,
            children: [
              Text("Canaan ", style: nameStyle),
              GradientText("Ozah.", style: nameStyle),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 300),
          child: Column(crossAxisAlignment: cross, children: [
            Text("I build", style: context.text.headlineSmall!.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: Typewriter(
                phrases: Profile.roles,
                style: context.text.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 400),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              Profile.bio,
              textAlign: align,
              style: context.text.bodyLarge!.copyWith(color: on.withValues(alpha: 0.7), height: 1.7),
            ),
          ),
        ),
        const SizedBox(height: 36),
        Reveal(
          delay: const Duration(milliseconds: 500),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: center ? WrapAlignment.center : WrapAlignment.start,
            children: [
              FireButton(label: "View my work", onPressed: onViewWork),
              GhostButton(
                label: "Download CV",
                icon: Icons.download_rounded,
                onPressed: () => openLink("assets/${Profile.cvAsset}"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        const Reveal(delay: Duration(milliseconds: 600), child: SocialRow()),
      ],
    );
  }
}

class _HeroArt extends StatelessWidget {
  const _HeroArt();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 300),
      from: const Offset(40, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Floating(
              child: HoverLift(
                tilt: true,
                radius: BorderRadius.circular(32),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: Brand.fire,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: AspectRatio(
                      aspectRatio: 1408 / 768,
                      child: Image.asset("images/header.png", fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -18,
              bottom: -26,
              child: Floating(
                amplitude: 6,
                period: const Duration(seconds: 3),
                child: _Badge(
                  leading: Image.asset("images/flutter_logo.png", width: 22),
                  title: "Flutter",
                  subtitle: "Expert",
                ),
              ),
            ),
            Positioned(
              right: -14,
              top: -22,
              child: Floating(
                amplitude: 7,
                period: const Duration(milliseconds: 3600),
                child: _Badge(
                  leading: const Icon(Icons.bolt_rounded, color: Brand.orange, size: 22),
                  title: "5+ years",
                  subtitle: "Shipping apps",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final Widget leading;
  final String title, subtitle;
  const _Badge({required this.leading, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.colors.onSurface.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 12)),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          leading,
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w700)),
            Text(subtitle,
                style: context.text.labelSmall!
                    .copyWith(color: context.colors.onSurface.withValues(alpha: 0.6))),
          ]),
        ]),
      );
}

/// Animated "mouse" scroll indicator.
class _ScrollCue extends StatefulWidget {
  const _ScrollCue();
  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Column(children: [
      Container(
        width: 26,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on.withValues(alpha: 0.3), width: 2),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => Align(
            alignment: Alignment(0, -0.6 + _c.value * 1.0),
            child: Opacity(
              opacity: 1 - _c.value,
              child: Container(
                width: 4,
                height: 8,
                decoration: BoxDecoration(color: Brand.orange, borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text("SCROLL",
          style: context.text.labelSmall!.copyWith(letterSpacing: 4, color: on.withValues(alpha: 0.4))),
    ]);
  }
}
