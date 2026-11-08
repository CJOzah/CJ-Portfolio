import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../data/portfolio_data.dart';
import '../github/project.dart';
import '../github/projects_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

const _clientFilter = "Client work";

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _pageSize = 6;
  String _filter = "All";
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProjectsStore>();
    final all = store.projects;

    // "Client work" (org apps) + top languages become filter chips.
    final counts = <String, int>{};
    for (final p in all) {
      if (p.language != null) counts[p.language!] = (counts[p.language!] ?? 0) + 1;
    }
    final filters = [
      "All",
      if (all.any((p) => p.isOrg)) _clientFilter,
      ...(counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!))).take(5),
    ];
    final filtered = switch (_filter) {
      "All" => all,
      _clientFilter => all.where((p) => p.isOrg).toList(),
      _ => all.where((p) => p.language == _filter).toList(),
    };
    final visible = _showAll ? filtered : filtered.take(_pageSize).toList();
    final columns = context.isMobile ? 1 : (context.isDesktop ? 3 : 2);

    return Section(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(
          eyebrow: "GitHub",
          title: "Recent apps",
          subtitle: "Applications from my GitHub and the organizations I work with.",
        ),
        if (store.loading)
          _Skeleton(columns: columns)
        else if (all.isEmpty)
          const _EmptyState()
        else ...[
          Reveal(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final f in filters)
                  ChoiceChip(
                    label: Text(f == "All" ? "All (${all.length})" : f),
                    avatar: f == _clientFilter
                        ? Icon(Icons.apartment_rounded,
                            size: 16, color: _filter == f ? context.colors.surface : context.colors.onSurface)
                        : null,
                    selected: _filter == f,
                    showCheckmark: false,
                    onSelected: (_) => setState(() {
                      _filter = f;
                      _showAll = false;
                    }),
                    selectedColor: context.colors.onSurface,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _filter == f ? context.colors.surface : context.colors.onSurface,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(color: context.colors.onSurface.withValues(alpha: 0.12)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: CardGrid(
              key: ValueKey("$_filter$_showAll"),
              columns: columns,
              children: [
                for (var i = 0; i < visible.length; i++)
                  Reveal(
                    delay: Duration(milliseconds: 80 * (i % columns)),
                    child: _ProjectCard(visible[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(spacing: 16, runSpacing: 16, children: [
            if (filtered.length > _pageSize)
              GhostButton(
                label: _showAll ? "Show less" : "Show all ${filtered.length}",
                icon: _showAll ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                onPressed: () => setState(() => _showAll = !_showAll),
              ),
            for (final s in storePages)
              GhostButton(label: s.label, icon: Icons.shop_rounded, onPressed: () => openLink(s.url)),
          ]),
        ],
      ]),
    );
  }
}

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 60) return "just now";
  if (d.inHours < 24) return "${d.inHours}h ago";
  if (d.inDays < 30) return "${d.inDays}d ago";
  return "on ${t.year}-${t.month.toString().padLeft(2, "0")}-${t.day.toString().padLeft(2, "0")}";
}

class _Cover extends StatelessWidget {
  final Project project;
  const _Cover(this.project);

  @override
  Widget build(BuildContext context) => Hero(
        tag: "project-${project.id}",
        child: project.image == null
            ? _Placeholder(title: project.title)
            : CachedNetworkImage(
                imageUrl: project.image!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => _Placeholder(title: project.title),
                errorWidget: (_, __, ___) => _Placeholder(title: project.title),
              ),
      );
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Semantics(
      button: true,
      label: "${project.title}: open details",
      child: HoverLift(
        onTap: () => showProjectDetail(context, project),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(fit: StackFit.expand, children: [
                _Cover(project),
                if (project.isOrg || project.isPrivate)
                  Positioned(left: 14, top: 14, child: _OwnerBadge(project)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(project.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 66,
                  child: Text(
                    project.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium!.copyWith(height: 1.6, color: on.withValues(alpha: 0.65)),
                  ),
                ),
                const SizedBox(height: 18),
                _MetaRow(project),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _OwnerBadge extends StatelessWidget {
  final Project project;
  const _OwnerBadge(this.project);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(project.isOrg ? Icons.apartment_rounded : Icons.lock_outline_rounded,
              size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Text(project.isOrg ? (project.owner ?? "Client work") : "Client work",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      );
}

class _MetaRow extends StatelessWidget {
  final Project project;
  final bool hint;
  const _MetaRow(this.project, {this.hint = true});

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Row(children: [
      if (project.language != null) ...[
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Brand.copper),
        ),
        const SizedBox(width: 6),
        Text(project.language!, style: context.text.labelMedium),
        const SizedBox(width: 16),
      ],
      if (project.stars > 0) ...[
        Icon(Icons.star_rounded, size: 16, color: on.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        Text("${project.stars}", style: context.text.labelMedium),
      ],
      if (hint) ...[
        const Spacer(),
        Text("Details", style: context.text.labelMedium!.copyWith(color: context.accentText)),
        const SizedBox(width: 4),
        Icon(Icons.north_east_rounded, size: 16, color: context.accentText),
      ],
    ]);
  }
}

/// Full-screen-ish detail sheet with a hero image transition.
Future<void> showProjectDetail(BuildContext context, Project p) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (_, a, __, child) => FadeTransition(
        opacity: a,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
      pageBuilder: (context, _, __) => _ProjectDetail(p),
    );

class _ProjectDetail extends StatelessWidget {
  final Project project;
  const _ProjectDetail(this.project);

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    final p = project;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 12 : 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  AspectRatio(aspectRatio: 16 / 9, child: _Cover(p)),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: IconButton.filled(
                      tooltip: "Close",
                      style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.5)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.all(context.isMobile ? 22 : 36),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (p.isOrg || p.isPrivate) ...[_OwnerBadge(p), const SizedBox(height: 14)],
                    Text(p.title,
                        style: context.text.headlineMedium!.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),
                    Text(p.summary,
                        style: context.text.bodyLarge!.copyWith(height: 1.75, color: on.withValues(alpha: 0.75))),
                    const SizedBox(height: 20),
                    _MetaRow(p, hint: false),
                    if (p.updated != null) ...[
                      const SizedBox(height: 8),
                      Text("Last updated ${_ago(p.updated!)}",
                          style: context.text.bodySmall!.copyWith(color: on.withValues(alpha: 0.5))),
                    ],
                    const SizedBox(height: 28),
                    Wrap(spacing: 14, runSpacing: 14, children: [
                      if (p.storeUrl != null)
                        PrimaryButton(
                          label: p.storeUrl!.contains("play.google.com") ? "Get it on Google Play" : "Open app",
                          icon: const Icon(Icons.shop_rounded),
                          onPressed: () => openLink(p.storeUrl!),
                        ),
                      if (p.sourceUrl != null)
                        GhostButton(
                          label: "View source",
                          icon: Icons.code_rounded,
                          onPressed: () => openLink(p.sourceUrl!),
                        ),
                      if (p.sourceUrl == null)
                        Chip(
                          avatar: const Icon(Icons.lock_outline_rounded, size: 16),
                          label: const Text("Private client code"),
                          side: BorderSide(color: on.withValues(alpha: 0.12)),
                        ),
                    ]),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient cover with the project's initials when there is no README image.
class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    final initials = title
        .split(RegExp(r"[\s_\-]+"))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Brand.navy, Color(0xFF28486B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(initials,
            style: context.text.displaySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  final int columns;
  const _Skeleton({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.onSurface.withValues(alpha: 0.06),
      highlightColor: context.colors.onSurface.withValues(alpha: 0.14),
      child: CardGrid(
        columns: columns,
        children: List.generate(
          columns * 2,
          (_) => Container(
            height: 360,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(children: [
          IconBadge(socials.first.icon),
          const SizedBox(height: 20),
          Text("Projects couldn't load right now.", style: context.text.titleMedium),
          const SizedBox(height: 20),
          PrimaryButton(
            label: "Browse them on GitHub",
            onPressed: () => openLink(socials.first.url),
          ),
        ]),
      );
}
