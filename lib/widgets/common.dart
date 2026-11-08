import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'effects.dart';

/// Centered max-width page column with responsive gutters.
class Section extends StatelessWidget {
  final Widget child;
  final double top, bottom;
  const Section({super.key, required this.child, this.top = 96, this.bottom = 96});

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.gutter, top, context.gutter, bottom),
            child: child,
          ),
        ),
      );
}

class SectionHeader extends StatelessWidget {
  final String eyebrow, title;
  final String? subtitle;
  const SectionHeader({super.key, required this.eyebrow, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => Reveal(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            eyebrow.toUpperCase(),
            style: context.text.labelMedium!.copyWith(
              color: context.accentText,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          WordReveal(
            title,
            style: context.text.headlineLarge!.copyWith(
              fontSize: context.isMobile ? 30 : 40,
              height: 1.15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                subtitle!,
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),
          ],
          const SizedBox(height: 48),
        ]),
      );
}

/// Equal-width wrapping grid; rows size to their content.
class CardGrid extends StatelessWidget {
  final int columns;
  final double gap;
  final List<Widget> children;
  const CardGrid({super.key, required this.columns, this.gap = 24, required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final w = (c.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final child in children) SizedBox(width: w, child: child)],
        );
      });
}

/// Primary action: solid, high-contrast in both themes.
class PrimaryButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = const Icon(Icons.arrow_forward_rounded),
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: widget.onPressed,
        onHover: (v) => setState(() => _hover = v),
        icon: AnimatedSlide(
          offset: Offset(_hover ? 0.3 : 0, 0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: IconTheme(data: IconThemeData(color: context.colors.surface, size: 18), child: widget.icon),
        ),
        iconAlignment: IconAlignment.end,
        label: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        style: FilledButton.styleFrom(
          backgroundColor: context.colors.onSurface,
          foregroundColor: context.colors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}

class GhostButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const GhostButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: context.colors.onSurface.withValues(alpha: 0.2)),
        ),
      );
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [for (final s in socials) _SocialIcon(s)],
      );
}

class _SocialIcon extends StatefulWidget {
  final Social social;
  const _SocialIcon(this.social);
  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onSurface;
    return Tooltip(
      message: widget.social.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => openLink(widget.social.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover ? on : null,
              border: Border.all(color: _hover ? on : on.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: FaIcon(widget.social.icon, size: 17, color: _hover ? context.colors.surface : on),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small rounded icon tile with gradient background.
class IconBadge extends StatelessWidget {
  final FaIconData icon;
  final double size;
  const IconBadge(this.icon, {super.key, this.size = 56});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: FaIcon(icon, color: context.colors.onSurface, size: size * 0.4)),
      );
}
