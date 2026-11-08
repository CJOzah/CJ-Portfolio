import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

/// Shipped products: the roles in [experience] that have an impact line.
class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = experience.where((r) => r.impact != null).toList();
    return Section(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(
          eyebrow: "Selected work",
          title: "Products in production",
          subtitle: "Most of my work lives in private client repositories, so here is what it delivered.",
        ),
        CardGrid(
          columns: context.isDesktop ? 3 : (context.isMobile ? 1 : 2),
          children: [
            for (var i = 0; i < featured.length; i++)
              Reveal(
                delay: Duration(milliseconds: 70 * i),
                child: HoverLift(
                  onTap: () => showCaseStudy(context, featured, i),
                  child: _WorkCard(featured[i]),
                ),
              ),
          ],
        ),
      ]),
    );
  }
}

class _WorkCard extends StatelessWidget {
  final Role role;
  const _WorkCard(this.role);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(role.field!.toUpperCase(),
          style: context.text.labelSmall!.copyWith(
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
            color: context.accentText,
          )),
      const SizedBox(height: 10),
      Text(role.company, style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 21)),
      const SizedBox(height: 10),
      Text(
        role.highlights.first,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodyMedium!.copyWith(height: 1.6, color: on.withValues(alpha: 0.72)),
      ),
      if (!context.isMobile) const Spacer() else const SizedBox(height: 18),
      Divider(height: 1, color: Theme.of(context).dividerColor),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(
          child: Text(role.impact!, style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Text("View case", style: context.text.labelMedium!.copyWith(color: context.accentText)),
        const SizedBox(width: 4),
        Icon(Icons.north_east_rounded, size: 14, color: context.accentText),
      ]),
    ]);
    return Panel(
      child: context.isMobile ? body : SizedBox(height: 264, child: body), // equal-height cards in the grid
    );
  }
}

/// Slide-in panel with the full story of a role; arrows step through [roles].
Future<void> showCaseStudy(BuildContext context, List<Role> roles, int index) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 380),
      transitionBuilder: (_, a, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: a, curve: Curves.easeOutQuint)),
        child: child,
      ),
      pageBuilder: (_, __, ___) => _CaseStudy(roles, index),
    );

class _CaseStudy extends StatefulWidget {
  final List<Role> roles;
  final int start;
  const _CaseStudy(this.roles, this.start);

  @override
  State<_CaseStudy> createState() => _CaseStudyState();
}

class _CaseStudyState extends State<_CaseStudy> {
  late int _i = widget.start;

  void _step(int by) => setState(() => _i = (_i + by + widget.roles.length) % widget.roles.length);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final r = widget.roles[_i];
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: width < 620 ? width : 560,
        child: Material(
          color: context.colors.surface,
          child: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(children: [
                  IconButton(
                      tooltip: "Previous",
                      onPressed: () => _step(-1),
                      icon: const Icon(Icons.arrow_back_rounded)),
                  IconButton(
                      tooltip: "Next",
                      onPressed: () => _step(1),
                      icon: const Icon(Icons.arrow_forward_rounded)),
                  const SizedBox(width: 8),
                  Text("${_i + 1} of ${widget.roles.length}",
                      style: context.text.labelMedium!.copyWith(color: on.withValues(alpha: 0.6))),
                  const Spacer(),
                  IconButton(
                    tooltip: "Close",
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ]),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  // Default layout centres content; a case study must start at the top.
                  layoutBuilder: (current, previous) =>
                      Stack(fit: StackFit.expand, children: [...previous, if (current != null) current]),
                  child: SingleChildScrollView(
                    key: ValueKey(_i),
                    padding: const EdgeInsets.all(32),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.field!.toUpperCase(),
                            style: context.text.labelSmall!.copyWith(
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                              color: context.accentText,
                            )),
                        const SizedBox(height: 10),
                        Text(r.company,
                            style: context.text.headlineMedium!
                                .copyWith(fontWeight: FontWeight.w600, fontSize: 32)),
                        const SizedBox(height: 6),
                        Text("${r.title} · ${r.period}",
                            style: context.text.bodyMedium!.copyWith(color: on.withValues(alpha: 0.65))),
                        const SizedBox(height: 24),
                        Text(r.impact!,
                            style: context.text.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.accentText,
                            )),
                        const SizedBox(height: 24),
                        for (final h in r.highlights)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Text(h,
                                style: context.text.bodyLarge!.copyWith(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: on.withValues(alpha: 0.78),
                                )),
                          ),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final t in r.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: on.withValues(alpha: 0.06),
                              ),
                              child: Text(t, style: context.text.labelMedium),
                            ),
                        ]),
                        if (r.link != null) ...[
                          const SizedBox(height: 28),
                          PrimaryButton(
                            label: "${r.link!.label} on Google Play",
                            onPressed: () => openLink(r.link!.url),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
