import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/code_window.dart';
import '../widgets/effects.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onContact;
  const AboutSection({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(eyebrow: "About", title: "End-to-end mobile engineering"),
      Reveal(
        child: Row(children: [
          ClipOval(
            child: Image.asset(
              "images/portrait.jpg",
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              semanticLabel: "Portrait of ${Profile.name}",
            ),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(Profile.name, style: context.text.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
            Text(Profile.tagline, style: context.text.bodySmall!.copyWith(color: on.withValues(alpha: 0.65))),
          ]),
        ]),
      ),
      const SizedBox(height: 24),
      Reveal(
        child: Text(
          Profile.about,
          style:
              context.text.bodyLarge!.copyWith(fontSize: 17, height: 1.7, color: on.withValues(alpha: 0.78)),
        ),
      ),
      const SizedBox(height: 28),
      Wrap(spacing: 12, runSpacing: 12, children: [
        PrimaryButton(label: "Get in touch", onPressed: onContact),
        GhostButton(
          label: "Download CV",
          icon: Icons.download_rounded,
          onPressed: () => openLink("assets/${Profile.cvAsset}"),
        ),
      ]),
    ]);

    final skills = Column(children: [
      Reveal(child: CodeWindow(basedIn: Profile.location.split(",").first)),
      const SizedBox(height: 20),
      const Reveal(child: _Skills()),
    ]);

    return Section(
      child: context.isDesktop
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 6, child: copy),
              const SizedBox(width: 72),
              Expanded(flex: 5, child: skills),
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 40), skills]),
    );
  }
}

/// Pick a technology to see which roles used it.
class _Skills extends StatefulWidget {
  const _Skills();

  @override
  State<_Skills> createState() => _SkillsState();
}

class _SkillsState extends State<_Skills> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final used = _selected == null ? <Role>[] : rolesUsing(_selected!);
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Technologies", style: context.text.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text("Select one to see where I've used it.",
            style: context.text.bodySmall!.copyWith(color: on.withValues(alpha: 0.65))),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in techStack)
            Semantics(
              selected: t == _selected,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: rolesUsing(t).isEmpty
                      ? null
                      : () => setState(() => _selected = t == _selected ? null : t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: t == _selected ? on : on.withValues(alpha: 0.05),
                    ),
                    child: Text(t,
                        style: context.text.labelLarge!.copyWith(
                          color: t == _selected ? context.colors.surface : on,
                        )),
                  ),
                ),
              ),
            ),
        ]),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topLeft,
          child: used.isEmpty
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "Used at  ",
                            style: TextStyle(color: on.withValues(alpha: 0.6)),
                          ),
                          TextSpan(
                            text: used.map((r) => r.company).join(", "),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ]),
                        style: context.text.bodyMedium!.copyWith(height: 1.5)),
                  ),
                ),
        ),
      ]),
    );
  }
}
