import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../data/portfolio_data.dart';
import '../github_api.dart';
import '../github_model.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class ProjectsSection extends StatefulWidget {
  final Future<void> loading;
  const ProjectsSection({super.key, required this.loading});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _pageSize = 6;
  String _filter = "All";
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final repos = context.watch<GithubRepos>();
    final all = repos.getGithubRepo();

    // Top languages by repo count become filter chips.
    final counts = <String, int>{};
    for (final r in all) {
      final lang = r.language;
      if (lang != null) counts[lang] = (counts[lang] ?? 0) + 1;
    }
    final languages = ["All", ...(counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!))).take(6)];
    final filtered = _filter == "All" ? all : all.where((r) => r.language == _filter).toList();
    final visible = _showAll ? filtered : filtered.take(_pageSize).toList();
    final columns = context.isDesktop ? 3 : (context.isMobile ? 1 : 2);

    return Section(
      child: Column(children: [
        const SectionHeader(
          eyebrow: "What I've built",
          title: "Featured projects",
          subtitle: "Pulled live from GitHub — apps, packages and experiments.",
        ),
        FutureBuilder<void>(
          future: widget.loading,
          builder: (context, snap) {
            if (all.isEmpty && snap.connectionState != ConnectionState.done) {
              return _Skeleton(columns: columns);
            }
            if (all.isEmpty) return const _EmptyState();
            return Column(children: [
              Reveal(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final l in languages)
                      ChoiceChip(
                        label: Text(l == "All" ? "All (${all.length})" : l),
                        selected: _filter == l,
                        showCheckmark: false,
                        onSelected: (_) => setState(() {
                          _filter = l;
                          _showAll = false;
                        }),
                        selectedColor: Brand.orange,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _filter == l ? Colors.white : context.colors.onSurface,
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
                child: _CardGrid(
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
              if (filtered.length > _pageSize)
                GhostButton(
                  label: _showAll ? "Show less" : "Show all ${filtered.length}",
                  icon: _showAll ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  onPressed: () => setState(() => _showAll = !_showAll),
                ),
            ]);
          },
        ),
      ]),
    );
  }
}

class _CardGrid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  const _CardGrid({super.key, required this.columns, required this.children});

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

class _ProjectCard extends StatelessWidget {
  final GithubRepo repo;
  const _ProjectCard(this.repo);

  @override
  Widget build(BuildContext context) {
    final api = context.read<GithubRepos>();
    final title = api.getRepoProjectHeading(repo);
    final image = api.getRepoReadmeHeaderImage(repo);
    final isPrivate = (repo.private ?? false) || api.isInvitedRepo(repo);
    final on = context.colors.onSurface;

    return HoverLift(
      onTap: () => openLink(api.getRepoProjectUrl(repo)),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.isDark ? Colors.white.withValues(alpha: 0.035) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: on.withValues(alpha: 0.08)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: image == null
                ? _Placeholder(title: title)
                : CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _Placeholder(title: title),
                    errorWidget: (_, __, ___) => _Placeholder(title: title),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
                ),
                if (!isPrivate && repo.htmlUrl != null)
                  IconButton(
                    tooltip: "View source",
                    onPressed: () => openLink(repo.htmlUrl!),
                    icon: FaIcon(FontAwesomeIcons.github, size: 18, color: on.withValues(alpha: 0.7)),
                  ),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                height: 66,
                child: Text(
                  api.getRepoProjectDescription(repo),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium!.copyWith(height: 1.6, color: on.withValues(alpha: 0.65)),
                ),
              ),
              const SizedBox(height: 18),
              Row(children: [
                if (repo.language != null) ...[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Brand.fire),
                  ),
                  const SizedBox(width: 6),
                  Text(repo.language!, style: context.text.labelMedium),
                  const SizedBox(width: 16),
                ],
                if ((repo.stargazersCount ?? 0) > 0) ...[
                  Icon(Icons.star_rounded, size: 16, color: on.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text("${repo.stargazersCount}", style: context.text.labelMedium),
                ],
                const Spacer(),
                if (isPrivate)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Brand.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Client work",
                        style: context.text.labelSmall!.copyWith(color: Brand.orange, fontWeight: FontWeight.w700)),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.north_east_rounded, size: 18, color: Brand.orange),
              ]),
            ]),
          ),
        ]),
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
          colors: [Brand.navy, Brand.orange.withValues(alpha: 0.6)],
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
    final base = context.colors.onSurface.withValues(alpha: 0.06);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: context.colors.onSurface.withValues(alpha: 0.14),
      child: _CardGrid(
        columns: columns,
        children: List.generate(
          columns * 2,
          (_) => Container(
            height: 360,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => GlassCard(
        child: Column(children: [
          const IconBadge(FontAwesomeIcons.github),
          const SizedBox(height: 20),
          Text("Projects couldn't load right now.", style: context.text.titleMedium),
          const SizedBox(height: 20),
          FireButton(
            label: "Browse them on GitHub",
            onPressed: () => openLink("https://github.com/${Profile.githubUser}"),
          ),
        ]),
      );
}
