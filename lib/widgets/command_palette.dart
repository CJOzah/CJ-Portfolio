import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class PaletteItem {
  final String title;
  final String group;
  final IconData icon;
  final VoidCallback run;
  const PaletteItem(this.title, this.group, this.icon, this.run);
}

/// Spotlight-style quick search: type to filter, ↑/↓ to move, Enter to run, Esc to close.
Future<void> showCommandPalette(BuildContext context, List<PaletteItem> items) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (_, a, __, child) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, -0.03), end: Offset.zero).animate(a),
          child: child,
        ),
      ),
      pageBuilder: (_, __, ___) => _Palette(items),
    );

class _Palette extends StatefulWidget {
  final List<PaletteItem> items;
  const _Palette(this.items);

  @override
  State<_Palette> createState() => _PaletteState();
}

class _PaletteState extends State<_Palette> {
  String _query = "";
  int _index = 0;

  List<PaletteItem> get _matches {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return widget.items;
    // Every typed word must appear in the title or group.
    final words = q.split(RegExp(r"\s+"));
    return widget.items.where((i) {
      final hay = "${i.title} ${i.group}".toLowerCase();
      return words.every(hay.contains);
    }).toList();
  }

  void _run(PaletteItem item) {
    Navigator.pop(context);
    item.run();
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final n = _matches.length;
    if (e.logicalKey == LogicalKeyboardKey.arrowDown && n > 0) {
      setState(() => _index = (_index + 1) % n);
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.arrowUp && n > 0) {
      setState(() => _index = (_index - 1 + n) % n);
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.enter && n > 0) {
      _run(_matches[_index.clamp(0, n - 1)]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final on = context.colors.onSurface;
    return Align(
      alignment: const Alignment(0, -0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620, maxHeight: 520),
          child: Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: Focus(
              onKeyEvent: _onKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  autofocus: true,
                  onChanged: (v) => setState(() {
                    _query = v;
                    _index = 0;
                  }),
                  decoration: const InputDecoration(
                    hintText: "Search sections, apps, jobs, actions…",
                    prefixIcon: Icon(Icons.search_rounded),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                Divider(height: 1, color: on.withValues(alpha: 0.08)),
                Flexible(
                  child: matches.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(28),
                          child: Text("No results for “$_query”",
                              style: TextStyle(color: on.withValues(alpha: 0.5))),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: matches.length,
                          itemBuilder: (_, i) {
                            final item = matches[i];
                            final active = i == _index;
                            return MouseRegion(
                              onEnter: (_) => setState(() => _index = i),
                              child: ListTile(
                                selected: active,
                                selectedTileColor: Brand.copper.withValues(alpha: 0.12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                leading: Icon(item.icon, color: active ? Brand.copper : on.withValues(alpha: 0.6)),
                                title: Text(item.title,
                                    style: TextStyle(color: on, fontWeight: FontWeight.w600)),
                                trailing: Text(item.group,
                                    style: context.text.labelSmall!.copyWith(color: on.withValues(alpha: 0.45))),
                                onTap: () => _run(item),
                              ),
                            );
                          },
                        ),
                ),
                Divider(height: 1, color: on.withValues(alpha: 0.08)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(children: [
                    Text("↑↓ navigate   ↵ open   esc close",
                        style: context.text.labelSmall!.copyWith(color: on.withValues(alpha: 0.45))),
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
