import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int _selected = 0;

  void _select(int i) => setState(() => _selected = i);

  @override
  Widget build(BuildContext context) {
    final detail = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(begin: const Offset(0.04, 0), end: Offset.zero).animate(a),
          child: child,
        ),
      ),
      child: _RoleCard(experience[_selected], key: ValueKey(_selected)),
    );

    return Section(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(
          eyebrow: "Where I've worked",
          title: "Experience",
          subtitle: "Event platforms, delivery logistics, healthcare and more: shipped and in production.",
        ),
        Reveal(
          child: Column(children: [
            context.isMobile
                ? _RoleChips(selected: _selected, onSelect: _select)
                : _CareerTimeline(selected: _selected, onSelect: _select),
            const SizedBox(height: 28),
            detail,
          ]),
        ),
      ]),
    );
  }
}

/// Gantt-style history: bars show when each role ran, including overlaps.
class _CareerTimeline extends StatelessWidget {
  static const _startYear = 2021.0, _rowHeight = 38.0, _labelRoom = 230.0;
  final int selected;
  final ValueChanged<int> onSelect;
  const _CareerTimeline({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final today = DateTime.now();
    final now = today.year + (today.month - 1) / 12;
    final endYear = now + 0.25;
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      double x(double year) => (year - _startYear) / (endYear - _startYear) * w;
      return VisibleBuilder(
        builder: (context, seen) => TweenAnimationBuilder<double>(
          tween: Tween(end: seen ? 1 : 0),
          duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 1700),
          builder: (context, grow, _) => SizedBox(
            height: 34 + experience.length * _rowHeight,
            child: Stack(children: [
              for (var y = 2021; y <= now; y++) ...[
                Positioned(left: x(y.toDouble()), top: 26, bottom: 0, child: Container(width: 1, color: Theme.of(context).dividerColor)),
                Positioned(
                  left: x(y.toDouble()),
                  top: 0,
                  child: Text("$y", style: context.text.labelMedium!.copyWith(color: on.withValues(alpha: 0.55))),
                ),
              ],
              Positioned(left: x(now), top: 26, bottom: 0, child: Container(width: 1.5, color: Brand.copper)),
              for (var i = 0; i < experience.length; i++) _bar(context, i, x, now, grow, w),
            ]),
          ),
        ),
      );
    });
  }

  Widget _bar(BuildContext context, int i, double Function(double) x, double now, double grow, double w) {
    final on = context.colors.onSurface;
    final r = experience[i];
    final active = i == selected;
    final left = x(r.from);
    final step = 0.48 / experience.length; // keeps every interval inside 0..1 however many roles exist
    final rowGrow = Interval(i * step, 0.52 + i * step, curve: Curves.easeOutQuint).transform(grow);
    final barWidth = (x(r.to ?? now) - left) * rowGrow;
    final labelInside = left + x(r.to ?? now) - x(r.from) + _labelRoom > w;
    final label = Text(
      r.company,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelLarge!.copyWith(
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        color: labelInside && active ? Brand.ink : (active ? on : on.withValues(alpha: 0.75)),
      ),
    );
    return Positioned(
      left: left,
      top: 34 + i * _rowHeight,
      height: _rowHeight - 8,
      right: 0,
      child: Semantics(
        button: true,
        selected: active,
        label: "${r.company}, ${r.period}",
        child: ExcludeSemantics(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(6),
              child: Stack(alignment: Alignment.centerLeft, children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: barWidth.clamp(6.0, double.infinity),
                  decoration: BoxDecoration(
                    color: active ? Brand.copper : on.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: labelInside ? 12 : (barWidth + 10).clamp(16.0, double.infinity)),
                  child: label,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChips extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _RoleChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: experience.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => ChoiceChip(
            label: Text(experience[i].company),
            selected: i == selected,
            showCheckmark: false,
            onSelected: (_) => onSelect(i),
            selectedColor: context.colors.onSurface,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: i == selected ? context.colors.surface : context.colors.onSurface,
            ),
            shape: const StadiumBorder(),
            side: BorderSide(color: context.colors.onSurface.withValues(alpha: 0.12)),
          ),
        ),
      );
}

class _RoleCard extends StatelessWidget {
  final Role role;
  const _RoleCard(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Panel(
      padding: const EdgeInsets.all(32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(
          TextSpan(children: [
            TextSpan(text: role.title),
            TextSpan(text: "  @ ", style: TextStyle(color: on.withValues(alpha: 0.4))),
            TextSpan(text: role.company, style: TextStyle(color: context.accentText)),
          ]),
          style: context.text.headlineSmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 16, runSpacing: 4, children: [
          _Meta(Icons.calendar_today_rounded, role.period),
          _Meta(Icons.place_outlined, role.location),
        ]),
        const SizedBox(height: 24),
        for (final (i, h) in role.highlights.indexed)
          StaggerIn(index: i, child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 4, right: 4),
                child: Icon(Icons.circle, color: Brand.copper, size: 6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(h,
                    style: context.text.bodyLarge!.copyWith(fontSize: 15, height: 1.6, color: on.withValues(alpha: 0.75))),
              ),
            ]),
          )),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in role.tags)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: on.withValues(alpha: 0.05),
                border: Border.all(color: on.withValues(alpha: 0.08)),
              ),
              child: Text(t, style: context.text.labelMedium),
            ),
        ]),
        if (role.link != null) ...[
          const SizedBox(height: 24),
          GhostButton(
            label: "See ${role.link!.label} on Google Play",
            icon: Icons.shop_rounded,
            onPressed: () => openLink(role.link!.url),
          ),
        ],
      ]),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final c = context.colors.onSurface.withValues(alpha: 0.55);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: c),
      const SizedBox(width: 6),
      Text(text, style: context.text.bodySmall!.copyWith(color: c)),
    ]);
  }
}
