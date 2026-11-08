import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../github_api.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onContact;
  const AboutSection({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final repoCount = context.select<GithubRepos, int>((r) => r.githubRepo.length);
    final stats = [
      const Stat(5, "+", "Years of experience"),
      if (repoCount > 0) Stat(repoCount, "", "GitHub repositories"),
      const Stat(4, "", "Platforms shipped to"),
    ];

    final photo = Reveal(
      from: const Offset(-40, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(clipBehavior: Clip.none, children: [
              // Offset gradient frame behind the photo.
              Positioned.fill(
                left: 16,
                top: 16,
                right: -16,
                bottom: -16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Brand.orange, width: 2),
                  ),
                ),
              ),
              Positioned.fill(
                child: HoverLift(
                  tilt: true,
                  radius: BorderRadius.circular(32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset("images/cj4.jpg", fit: BoxFit.cover),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );

    final copy = Column(
      crossAxisAlignment: desktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SectionHeader(eyebrow: "Who I am", title: "About me", center: !desktop),
        Reveal(
          child: Text(
            Profile.about,
            textAlign: desktop ? TextAlign.start : TextAlign.center,
            style: context.text.bodyLarge!.copyWith(
              height: 1.8,
              color: context.colors.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ),
        const SizedBox(height: 36),
        Reveal(
          delay: const Duration(milliseconds: 150),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [for (final s in stats) _StatTile(s)],
          ),
        ),
        const SizedBox(height: 36),
        Reveal(
          delay: const Duration(milliseconds: 250),
          child: Wrap(spacing: 16, runSpacing: 16, children: [
            FireButton(label: "Let's talk", onPressed: onContact),
            GhostButton(
              label: "Download CV",
              icon: Icons.download_rounded,
              onPressed: () => openLink("assets/${Profile.cvAsset}"),
            ),
          ]),
        ),
      ],
    );

    return Section(
      child: desktop
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 5, child: photo),
              const SizedBox(width: 80),
              Expanded(flex: 6, child: copy),
            ])
          : Column(children: [copy, const SizedBox(height: 56), photo]),
    );
  }
}

class _StatTile extends StatelessWidget {
  final Stat stat;
  const _StatTile(this.stat);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 160,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CountUp(
              // Re-key so the counter replays when the live repo count arrives.
              key: ValueKey(stat.value),
              value: stat.value,
              suffix: stat.suffix,
              style: context.text.headlineLarge!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(stat.label,
                style: context.text.bodySmall!
                    .copyWith(color: context.colors.onSurface.withValues(alpha: 0.6))),
          ]),
        ),
      );
}
