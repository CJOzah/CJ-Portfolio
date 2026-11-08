import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(eyebrow: "Services", title: "What I do"),
          CardGrid(
            columns: context.isDesktop ? 3 : (context.isMobile ? 1 : 2),
            children: [
              for (var i = 0; i < services.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 80 * i),
                  child: HoverLift(child: Panel(child: _ServiceBlock(services[i]))),
                ),
            ],
          ),
          const SizedBox(height: 88),
          const SectionHeader(
            eyebrow: "Process",
            title: "Every project ships through one pipeline",
          ),
          const Reveal(child: _Pipeline()),
        ]),
      );
}

class _ServiceBlock extends StatelessWidget {
  final Service item;
  const _ServiceBlock(this.item);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.title, style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700, fontSize: 19)),
        const SizedBox(height: 10),
        Text(item.body,
            style: context.text.bodyMedium!.copyWith(height: 1.6, color: context.colors.onSurface.withValues(alpha: 0.72))),
      ]);
}

/// A CI-style run: each stage spins, then ticks, the first time it scrolls into view.
class _Pipeline extends StatelessWidget {
  const _Pipeline();

  @override
  Widget build(BuildContext context) {
    final horizontal = context.isDesktop;
    return Panel(
      child: VisibleBuilder(
        builder: (context, seen) => TweenAnimationBuilder<double>(
          tween: Tween(end: seen ? process.length.toDouble() : 0),
          duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 4200),
          builder: (context, run, _) {
            final steps = [
              for (var i = 0; i < process.length; i++)
                _Stage(process[i], progress: (run - i).clamp(0.0, 1.0), last: i == process.length - 1, horizontal: horizontal),
            ];
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(run >= process.length ? Icons.check_circle_rounded : Icons.autorenew_rounded,
                    size: 18, color: run >= process.length ? const Color(0xFF22A06B) : Brand.copper),
                const SizedBox(width: 8),
                Text(run >= process.length ? "Ready to release" : "Running ${process[run.floor().clamp(0, process.length - 1)].title}",
                    style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 24),
              horizontal
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [for (final s in steps) Expanded(child: s)])
                  : Column(children: steps),
            ]);
          },
        ),
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  final Service step;
  final double progress;
  final bool last, horizontal;
  const _Stage(this.step, {required this.progress, required this.last, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final done = progress >= 1;
    final node = SizedBox.square(
      dimension: 30,
      child: done
          ? Container(
              decoration: const BoxDecoration(color: Color(0xFF22A06B), shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
            )
          : CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              color: Brand.copper,
              backgroundColor: on.withValues(alpha: 0.12),
            ),
    );
    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(step.title, style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text(step.body,
          style: context.text.bodySmall!.copyWith(fontSize: 13, height: 1.55, color: on.withValues(alpha: 0.7))),
    ]);
    final track = LinearProgressIndicator(
      value: done ? 1 : 0,
      minHeight: 2,
      color: const Color(0xFF22A06B),
      backgroundColor: on.withValues(alpha: 0.12),
    );
    if (horizontal) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [node, if (!last) Expanded(child: track)]),
        const SizedBox(height: 16),
        Padding(padding: const EdgeInsets.only(right: 22), child: copy),
      ]);
    }
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Column(children: [
          node,
          if (!last)
            Expanded(
              child: Container(width: 2, color: done ? const Color(0xFF22A06B) : on.withValues(alpha: 0.12)),
            ),
        ]),
        const SizedBox(width: 16),
        Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 22, top: 4), child: copy)),
      ]),
    );
  }
}
