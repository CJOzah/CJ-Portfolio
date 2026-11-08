import 'dart:async';

import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/dot_field.dart';
import '../widgets/effects.dart';
import '../widgets/phone_showcase.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;
  const HeroSection({super.key, required this.onViewWork});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final mobile = context.isMobile;
    final on = context.colors.onSurface;
    final headline = context.text.displayMedium!.copyWith(
      fontSize: desktop ? 72 : (mobile ? 44 : 60),
      height: 1.08,
      fontWeight: FontWeight.w700,
      letterSpacing: desktop ? -2 : -1.2,
    );

    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        const PulseDot(),
        const SizedBox(width: 8),
        Text(
          "Senior Flutter Developer",
          style: context.text.titleSmall!.copyWith(color: on.withValues(alpha: 0.85), fontWeight: FontWeight.w600),
        ),
        Text(
          "   Available for work",
          style: context.text.titleSmall!.copyWith(color: context.accentText, fontWeight: FontWeight.w500),
        ),
      ]),
      const SizedBox(height: 22),
      Semantics(
        header: true,
        child: WordReveal(
          "Mobile apps built for the real world.",
          style: headline,
          accentFrom: 5,
          accent: context.accentText,
        ),
      ),
      const SizedBox(height: 26),
      Reveal(
        delay: const Duration(milliseconds: 420),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            Profile.bio,
            style: context.text.bodyLarge!.copyWith(fontSize: 19, height: 1.6, color: on.withValues(alpha: 0.72)),
          ),
        ),
      ),
      const SizedBox(height: 38),
      Reveal(
        delay: const Duration(milliseconds: 540),
        child: Wrap(spacing: 12, runSpacing: 12, children: [
          PrimaryButton(label: "View selected work", onPressed: onViewWork),
          GhostButton(
            label: "Download CV",
            icon: Icons.download_rounded,
            onPressed: () => openLink("assets/${Profile.cvAsset}"),
          ),
        ]),
      ),
      const SizedBox(height: 40),
      Reveal(
        delay: const Duration(milliseconds: 660),
        child: Wrap(spacing: 24, runSpacing: 14, crossAxisAlignment: WrapCrossAlignment.center, children: const [
          SocialRow(),
          _LocalClock(),
        ]),
      ),
    ]);

    return DotField(
      child: Section(
        top: mobile ? 116 : 148,
        bottom: 72,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          desktop
              ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: copy),
                  const SizedBox(width: 56),
                  const Reveal(delay: Duration(milliseconds: 260), child: PhoneShowcase()),
                  const SizedBox(width: 30),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  copy,
                  const SizedBox(height: 64),
                  Center(child: Reveal(child: PhoneShowcase(width: mobile ? 240 : 270))),
                ]),
          const SizedBox(height: 80),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          const SizedBox(height: 36),
          CardGrid(
            columns: mobile ? 2 : 4,
            children: [for (final s in stats) _StatBlock(s)],
          ),
          const SizedBox(height: 44),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Companies I've built for",
                  style: context.text.labelMedium!.copyWith(color: on.withValues(alpha: 0.6))),
              const SizedBox(height: 12),
              Wrap(spacing: 28, runSpacing: 8, children: [
                for (final r in experience)
                  Text(r.company,
                      style: context.text.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: on.withValues(alpha: 0.82),
                      )),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// West Africa Time is UTC+1 all year (no daylight saving).
String watTime(DateTime now) {
  final t = now.toUtc().add(const Duration(hours: 1));
  String two(int n) => n.toString().padLeft(2, "0");
  return "${two(t.hour)}:${two(t.minute)} WAT";
}

class _LocalClock extends StatefulWidget {
  const _LocalClock();

  @override
  State<_LocalClock> createState() => _LocalClockState();
}

class _LocalClockState extends State<_LocalClock> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        "Port Harcourt, Nigeria  ${watTime(DateTime.now())}",
        style: context.text.bodySmall!.copyWith(color: context.colors.onSurface.withValues(alpha: 0.65)),
      );
}

class _StatBlock extends StatelessWidget {
  final Stat stat;
  const _StatBlock(this.stat);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CountUp(
          value: stat.value,
          suffix: stat.suffix,
          style: context.text.headlineLarge!.copyWith(
            fontSize: 42,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 2),
        Text(stat.label,
            style: context.text.bodyMedium!.copyWith(color: context.colors.onSurface.withValues(alpha: 0.65))),
      ]);
}
