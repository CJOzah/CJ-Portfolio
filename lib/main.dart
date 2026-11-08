import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/portfolio_data.dart';
import 'github/projects_store.dart';
import 'home_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ProjectsStore()..load()),
        ],
        builder: (context, _) => MaterialApp(
          title: "${Profile.name} · ${Profile.tagline}",
          debugShowCheckedModeBanner: false,
          themeMode: context.watch<ThemeProvider>().themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeAnimationDuration: Duration.zero, // HomePage runs its own circular wipe
          home: const HomePage(),
        ),
      );
}
