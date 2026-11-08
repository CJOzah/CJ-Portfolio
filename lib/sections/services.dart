import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = context.isDesktop ? 3 : (context.isMobile ? 1 : 2);
    return Section(
      child: Column(children: [
        const SectionHeader(
          eyebrow: "What I do",
          title: "Services",
          subtitle: "From the first sketch to the store listing — design, build and ship.",
        ),
        _Grid(
          columns: columns,
          children: [
            for (var i = 0; i < services.length; i++)
              Reveal(
                delay: Duration(milliseconds: 120 * i),
                child: _ServiceCard(services[i], index: i),
              ),
          ],
        ),
        const SizedBox(height: 120),
        const SectionHeader(
          eyebrow: "Workflow",
          title: "How I work",
          subtitle: "A clear, repeatable process so you always know what's next.",
        ),
        const _ProcessTimeline(),
      ]),
    );
  }
}

/// Simple equal-width wrapping grid that sizes rows to content.
class _Grid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  const _Grid({required this.columns, required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        const gap = 24.0;
        final w = (c.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final child in children) SizedBox(width: w, child: child)],
        );
      });
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final int index;
  const _ServiceCard(this.service, {required this.index});

  @override
  Widget build(BuildContext context) => HoverLift(
        tilt: true,
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 240),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconBadge(service.icon),
                const Spacer(),
                Text(
                  "0${index + 1}",
                  style: context.text.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface.withValues(alpha: 0.08),
                  ),
                ),
              ]),
              const SizedBox(height: 28),
              Text(service.title,
                  style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(
                service.body,
                style: context.text.bodyMedium!.copyWith(
                  height: 1.7,
                  color: context.colors.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ]),
          ),
        ),
      );
}

class _ProcessTimeline extends StatelessWidget {
  const _ProcessTimeline();

  @override
  Widget build(BuildContext context) {
    final horizontal = context.isDesktop;
    final steps = [
      for (var i = 0; i < process.length; i++)
        Reveal(
          delay: Duration(milliseconds: 120 * i),
          from: horizontal ? const Offset(0, 40) : const Offset(40, 0),
          child: _Step(process[i], number: i + 1, horizontal: horizontal),
        ),
    ];

    if (!horizontal) {
      return Stack(children: [
        Positioned(
          left: 27,
          top: 28,
          bottom: 28,
          child: Container(width: 2, decoration: const BoxDecoration(gradient: Brand.fire)),
        ),
        Column(children: [
          for (final s in steps) Padding(padding: const EdgeInsets.only(bottom: 28), child: s),
        ]),
      ]);
    }

    return Stack(children: [
      Positioned(
        left: 0,
        right: 0,
        top: 27,
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Brand.orange.withValues(alpha: 0),
              Brand.orange,
              Brand.ember,
              Brand.ember.withValues(alpha: 0),
            ]),
          ),
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in steps)
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: s)),
        ],
      ),
    ]);
  }
}

class _Step extends StatelessWidget {
  final Service step;
  final int number;
  final bool horizontal;
  const _Step(this.step, {required this.number, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    final node = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Brand.orange, width: 2),
      ),
      child: Center(
        child: GradientText("$number",
            style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
    final copy = Column(
      crossAxisAlignment: horizontal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(step.title, style: context.text.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          step.body,
          textAlign: horizontal ? TextAlign.center : TextAlign.start,
          style: context.text.bodySmall!.copyWith(
            height: 1.6,
            color: context.colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
    return horizontal
        ? Column(children: [node, const SizedBox(height: 20), copy])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            node,
            const SizedBox(width: 20),
            Expanded(child: Padding(padding: const EdgeInsets.only(top: 6), child: copy)),
          ]);
  }
}
