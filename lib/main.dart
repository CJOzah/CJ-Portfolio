// @dart=2.9

import 'package:canaan_portfolio/github_api.dart';
import 'package:canaan_portfolio/screens/home.dart';
import 'package:canaan_portfolio/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// int? isviewed;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Canaan());
}

class Canaan extends StatelessWidget {
  static String title = "RentalStop";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (context) => GithubRepos(),
          ),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: MyThemes.darkTheme,
              darkTheme: MyThemes.darkTheme,
              initialRoute: Home.id,
              debugShowCheckedModeBanner: false,
              routes: {
                Home.id: (context) => Home(),
              });
        },
      );
}
