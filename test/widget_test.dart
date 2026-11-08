import 'package:canaan_portfolio/github/project.dart';
import 'package:canaan_portfolio/widgets/brand_logo.dart';
import 'package:canaan_portfolio/widgets/command_palette.dart';
import 'package:canaan_portfolio/widgets/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Typewriter types, then rotates to the next phrase', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Typewriter(phrases: ["ab", "cd"])));
    String shown() => tester.widget<Text>(find.byType(Text)).data!;

    await tester.pump(const Duration(milliseconds: 70));
    await tester.pump(const Duration(milliseconds: 70));
    expect(shown(), "ab");
    // pause, delete 2 chars, switch phrase, type one char (35ms steps)
    await tester.pump(const Duration(milliseconds: 1600));
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 35));
    }
    expect(shown(), "c");
    await tester.pump(const Duration(milliseconds: 70));
    expect(shown(), "cd");
  });

  testWidgets('BrandLogo animates in without errors', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Center(child: BrandLogo(size: 120, animateIn: true))));
    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.bySemanticsLabel("CJ logo"), findsOneWidget);
  });

  testWidgets('Marquee lays out inside an unbounded Column', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SingleChildScrollView(child: Column(children: [Marquee(children: [Text("Flutter"), Text("Dart")])])),
    ));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.text("Flutter"), findsWidgets);
  });

  test('Project survives the snapshot JSON round-trip', () {
    final p = Project(
      id: "org/app", title: "App", summary: "S", image: "projects/app-0.png",
      storeUrl: "https://play.google.com/x", language: "Dart", stars: 3,
      updated: DateTime.utc(2026, 1, 2), owner: "org", isOrg: true, isPrivate: true,
    );
    final back = Project.fromJson(p.toJson());
    expect(back.toJson(), p.toJson());
    expect(back.sourceUrl, isNull);
  });

  testWidgets('Command palette filters and runs with the keyboard', (tester) async {
    final ran = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => showCommandPalette(context, [
            PaletteItem("Go to About", "Section", Icons.person, () => ran.add("about")),
            PaletteItem("Download CV", "Action", Icons.download, () => ran.add("cv")),
            PaletteItem("Copy email address", "Action", Icons.copy, () => ran.add("email")),
          ]),
          child: const Text("open"),
        ),
      ),
    ));
    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), "action");
    await tester.pump();
    expect(find.text("Go to About"), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(ran, ["email"]);
    expect(find.byType(TextField), findsNothing);
  });
}
