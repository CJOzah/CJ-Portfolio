import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'effects.dart';

/// Centered max-width page column with responsive gutters.
class Section extends StatelessWidget {
  final Widget child;
  final double top, bottom;
  const Section({super.key, required this.child, this.top = 110, this.bottom = 30});

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
  final bool center;
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Reveal(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 28, height: 2, decoration: const BoxDecoration(gradient: Brand.fire)),
              const SizedBox(width: 10),
              Text(
                eyebrow.toUpperCase(),
                style: context.text.labelLarge!.copyWith(
                  color: Brand.orange,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: (context.isMobile ? context.text.headlineLarge : context.text.displaySmall)!
                .copyWith(fontWeight: FontWeight.w700, letterSpacing: -1),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                subtitle!,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurface.withValues(alpha: 0.65),
                  height: 1.6,
                ),
              ),
            ),
          ],
          const SizedBox(height: 56),
        ],
      ),
    );
  }
}

/// Primary call-to-action with the fire gradient and an arrow that slides on hover.
class FireButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  const FireButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = const Icon(Icons.arrow_forward_rounded),
  });

  @override
  State<FireButton> createState() => _FireButtonState();
}

class _FireButtonState extends State<FireButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          gradient: Brand.fire,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Brand.orange.withValues(alpha: _hover ? 0.55 : 0.3),
              blurRadius: _hover ? 32 : 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.only(left: _hover ? 16 : 10),
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.white, size: 18),
                    child: widget.icon,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
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
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          shape: const StadiumBorder(),
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
            width: 46,
            height: 46,
            transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _hover ? Brand.fire : null,
              border: Border.all(color: _hover ? Colors.transparent : on.withValues(alpha: 0.15)),
            ),
            child: Center(
              child: FaIcon(widget.social.icon, size: 17, color: _hover ? Colors.white : on),
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
          gradient: Brand.fire,
          borderRadius: BorderRadius.circular(size * 0.3),
          boxShadow: [
            BoxShadow(color: Brand.orange.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Center(child: FaIcon(icon, color: Colors.white, size: size * 0.4)),
      );
}
