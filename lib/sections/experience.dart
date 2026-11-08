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
    final desktop = context.isDesktop;
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
      child: Column(children: [
        const SectionHeader(
          eyebrow: "Where I've worked",
          title: "Experience",
          subtitle: "Event platforms, delivery logistics, healthcare and more: shipped and in production.",
        ),
        Reveal(
          child: desktop
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 320, child: _RoleList(selected: _selected, onSelect: _select)),
                  const SizedBox(width: 32),
                  Expanded(child: detail),
                ])
              : Column(children: [
                  _RoleChips(selected: _selected, onSelect: _select),
                  const SizedBox(height: 20),
                  detail,
                ]),
        ),
      ]),
    );
  }
}

class _RoleList extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _RoleList({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Column(children: [
      for (var i = 0; i < experience.length; i++)
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: i == selected ? Brand.orange.withValues(alpha: 0.1) : Colors.transparent,
              ),
              child: Row(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 3,
                  height: i == selected ? 34 : 14,
                  decoration: BoxDecoration(
                    gradient: i == selected ? Brand.fire : null,
                    color: i == selected ? null : on.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(experience[i].company,
                        style: context.text.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: i == selected ? on : on.withValues(alpha: 0.6),
                        )),
                    Text(experience[i].period,
                        style: context.text.labelSmall!.copyWith(color: on.withValues(alpha: 0.45))),
                  ]),
                ),
              ]),
            ),
          ),
        ),
    ]);
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
            selectedColor: Brand.orange,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: i == selected ? Colors.white : context.colors.onSurface,
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
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(
          TextSpan(children: [
            TextSpan(text: role.title),
            TextSpan(text: "  @ ", style: TextStyle(color: on.withValues(alpha: 0.4))),
            TextSpan(text: role.company, style: const TextStyle(color: Brand.orange)),
          ]),
          style: context.text.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 16, runSpacing: 4, children: [
          _Meta(Icons.calendar_today_rounded, role.period),
          _Meta(Icons.place_outlined, role.location),
        ]),
        const SizedBox(height: 24),
        for (final h in role.highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.arrow_right_rounded, color: Brand.orange, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(h,
                    style: context.text.bodyLarge!.copyWith(height: 1.6, color: on.withValues(alpha: 0.75))),
              ),
            ]),
          ),
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
