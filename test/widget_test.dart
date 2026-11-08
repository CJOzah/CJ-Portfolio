import 'package:canaan_portfolio/data/portfolio_data.dart';
import 'package:canaan_portfolio/github/project.dart';
import 'package:canaan_portfolio/sections/contact.dart';
import 'package:canaan_portfolio/sections/hero.dart';
import 'package:canaan_portfolio/sections/showcase.dart';
import 'package:canaan_portfolio/sections/work.dart';
import 'package:canaan_portfolio/widgets/brand_logo.dart';
import 'package:canaan_portfolio/widgets/command_palette.dart';
import 'package:canaan_portfolio/widgets/effects.dart';
import 'package:canaan_portfolio/widgets/phone_showcase.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BrandLogo paints without errors', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Center(child: BrandLogo(size: 120))));
    expect(find.bySemanticsLabel("CJ logo"), findsOneWidget);
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

  test('watTime is UTC+1 and wraps past midnight', () {
    expect(watTime(DateTime.utc(2026, 1, 1, 23, 5)), "00:05 WAT");
    expect(watTime(DateTime.utc(2026, 7, 1, 8, 30)), "09:30 WAT");
  });

  test('rolesUsing finds roles by exact tag', () {
    expect(rolesUsing("WordPress").map((r) => r.company), ["Conference360"]);
    expect(rolesUsing("Bloc"), isEmpty);
  });

  testWidgets('CountUp lands on the final value', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CountUp(value: 50, suffix: "K+"))));
    await tester.pumpAndSettle();
    expect(find.text("50K+"), findsOneWidget);
  });

  testWidgets('Case study opens and steps to the next role', (tester) async {
    final featured = experience.where((r) => r.impact != null).toList();
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) =>
            TextButton(onPressed: () => showCaseStudy(context, featured, 0), child: const Text("open")),
      ),
    ));
    await tester.tap(find.text("open"));
    await tester.pumpAndSettle();
    expect(find.text(featured[0].company), findsOneWidget);
    await tester.tap(find.byTooltip("Next"));
    await tester.pumpAndSettle();
    expect(find.text(featured[1].company), findsOneWidget);
    expect(find.text(featured[0].company), findsNothing);
  });

  testWidgets('PhoneShowcase switches demo from its tabs', (tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: PhoneShowcase()))));
    await tester.pump();
    expect(find.text("On the way"), findsOneWidget);
    await tester.tap(find.text("EventPadi"));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("Summit Day Pass"), findsOneWidget);
    await tester.pumpWidget(const SizedBox()); // stops the looping animation
  });

  test('contactMessage omits empty fields', () {
    expect(contactMessage(" Ada ", "a@b.co", "", " Hi "), "Hello, I am Ada.\nEmail: a@b.co\nHi");
    expect(contactMessage("", "", "", ""), "");
  });

  test('every app preview has its bundled assets', () {
    for (final a in apps) {
      expect(File(a.icon).existsSync(), isTrue, reason: a.icon);
      for (var i = 0; i < a.shots; i++) {
        expect(File(a.shot(i)).existsSync(), isTrue, reason: a.shot(i));
      }
    }
  });

  testWidgets('Showcase switches app from the dock', (tester) async {
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SingleChildScrollView(child: ShowcaseSection()))));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(apps.first.blurb), findsOneWidget);
    await tester.tap(find.byTooltip("Trackpadi"));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("In development"), findsOneWidget);
    await tester.pumpWidget(const SizedBox()); // stops the auto-advance timer
    await tester.pump(const Duration(seconds: 1));
  });
}
