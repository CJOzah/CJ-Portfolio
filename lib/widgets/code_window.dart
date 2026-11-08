import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'effects.dart';

const _keyword = Color(0xFFD08A4E), _type = Color(0xFF7CC4E8), _string = Color(0xFF9BD08A), _plain = Color(0xFFD6DEE8);

/// Profile written as Dart, typed out the first time it scrolls into view.
class CodeWindow extends StatelessWidget {
  final String basedIn;
  const CodeWindow({super.key, required this.basedIn});

  List<(String, Color)> get _tokens => [
        ("class ", _keyword), ("CanaanOzah ", _type), ("extends ", _keyword), ("Engineer ", _type), ("{\n", _plain),
        ("  final ", _keyword), ("role = ", _plain), ("'Senior Flutter Developer'", _string), (";\n", _plain),
        ("  final ", _keyword), ("basedIn = ", _plain), ("'$basedIn'", _string), (";\n", _plain),
        ("  final ", _keyword), ("yearsShipping = ", _plain), ("5", _type), (";\n\n", _plain),
        ("  List", _type), ("<", _plain), ("String", _type), ("> ", _plain), ("get ", _keyword), ("focus => [\n", _plain),
        ("    'real-time event platforms'", _string), (",\n", _plain),
        ("    'live-tracking delivery'", _string), (",\n", _plain),
        ("    'payments and store releases'", _string), (",\n", _plain),
        ("  ];\n\n", _plain),
        ("  Future", _type), ("<", _plain), ("void", _keyword), ("> ", _plain), ("buildYourApp", _type),
        ("() ", _plain), ("async ", _keyword), ("=> ship();\n", _plain),
        ("}", _plain),
      ];

  @override
  Widget build(BuildContext context) {
    final tokens = _tokens;
    final total = tokens.fold<int>(0, (n, t) => n + t.$1.length);
    final mono = GoogleFonts.jetBrainsMono(fontSize: context.isMobile ? 11.5 : 13, height: 1.65);
    return Semantics(
      label: "Code-style profile: Senior Flutter Developer based in $basedIn, focused on real-time event platforms, "
          "live-tracking delivery, payments and store releases.",
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0B1522),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF263A50)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(children: [
                for (final c in const [Color(0xFFFF5F57), Color(0xFFFEBC2E), Color(0xFF28C840)])
                  Container(
                    width: 11,
                    height: 11,
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                const SizedBox(width: 8),
                Text("canaan_ozah.dart", style: mono.copyWith(fontSize: 12, color: const Color(0x99FFFFFF))),
              ]),
            ),
            const Divider(height: 1, color: Color(0xFF263A50)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: VisibleBuilder(
                builder: (context, seen) => TweenAnimationBuilder<double>(
                  tween: Tween(end: seen ? total.toDouble() : 0),
                  duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 2600),
                  builder: (_, typed, __) {
                    var left = typed.round();
                    return Text.rich(
                      TextSpan(children: [
                        for (final (text, color) in tokens) ...() {
                          final shown = left.clamp(0, text.length);
                          left -= shown;
                          // Untyped text stays in the layout, invisible, so the card never changes height.
                          return [
                            TextSpan(text: text.substring(0, shown), style: TextStyle(color: color)),
                            TextSpan(text: text.substring(shown), style: const TextStyle(color: Colors.transparent)),
                          ];
                        }(),
                      ]),
                      style: mono,
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
