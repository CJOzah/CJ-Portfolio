import 'package:canaan_portfolio/widgets/brand_logo.dart';
import 'package:canaan_portfolio/widgets/effects.dart';
import 'package:flutter/material.dart';
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
}
