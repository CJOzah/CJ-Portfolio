import 'package:flutter/material.dart';
// ignore_for_file: deprecated_member_use

class AppPalette {
  static const Color primary = Color(0xFF03273f);
  static const Color secondary = Color(0xFF0F4C5C);
  static const Color background = Color(0xFFF8F9FA);
  static const Color accent = Color(0xFFf2842f);
  static const Color text = Color(0xFF1B263B);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppPalette.primary,
    primaryColor: AppPalette.primary,
    primaryColorDark: AppPalette.text,
    primaryColorLight: AppPalette.secondary,
    secondaryHeaderColor: AppPalette.accent,
    splashColor: Color(0xFFf2842f),
    dividerColor: AppPalette.secondary.withValues(alpha: 0.35),
    textTheme: TextTheme().copyWith(
      bodyLarge: TextStyle(
        color: AppPalette.background,
        height: 1.5,
        fontSize: 16.0,
      ),
      bodyMedium: TextStyle(
        color: AppPalette.background,
      ),
      headlineMedium: TextStyle(
        color: AppPalette.background,
      ),
      headlineSmall: TextStyle(
        color: AppPalette.background,
      ),
      titleLarge: TextStyle(
        color: AppPalette.background,
      ),
      displaySmall: TextStyle(
        color: AppPalette.background,
      ),
    ),
    buttonTheme: ButtonThemeData().copyWith(
      buttonColor: AppPalette.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppPalette.secondary,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.only(left: 45.0, right: 45.0, top: 20.0, bottom: 20.0),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(fontSize: 15.0, color: AppPalette.background),
        ),
        elevation: MaterialStateProperty.all<double>(15.0),
        shadowColor: MaterialStateProperty.all<Color>(
          AppPalette.text,
        ),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppPalette.primary,
      secondary: AppPalette.accent,
      surface: AppPalette.secondary,
      onPrimary: AppPalette.background,
      onSecondary: AppPalette.text,
      onSurface: AppPalette.background,
    ),
    iconTheme: IconThemeData(
      color: AppPalette.background,
      opacity: 0.8,
      size: 24,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppPalette.background,
    primaryColor: AppPalette.primary,
    primaryColorDark: AppPalette.text,
    primaryColorLight: AppPalette.secondary,
    secondaryHeaderColor: AppPalette.accent,
    dividerColor: Colors.white,
    textTheme: TextTheme().copyWith(
      bodyLarge: TextStyle(
        color: AppPalette.text,
        fontSize: 16.0,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: AppPalette.text,
      ),
      headlineMedium: TextStyle(
        color: AppPalette.text,
      ),
      headlineSmall: TextStyle(
        color: AppPalette.text,
      ),
      titleLarge: TextStyle(
        color: AppPalette.text,
      ),
      displaySmall: TextStyle(
        color: AppPalette.text,
      ),
    ),
    buttonTheme: ButtonThemeData().copyWith(
      buttonColor: AppPalette.primary,
      hoverColor: AppPalette.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppPalette.primary,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.only(left: 45.0, right: 45.0, top: 20.0, bottom: 20.0),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 15.0,
            color: AppPalette.background,
          ),
        ),
        elevation: MaterialStateProperty.all<double>(15.0),
        shadowColor: MaterialStateProperty.all<Color>(AppPalette.text),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: AppPalette.primary,
      secondary: AppPalette.accent,
      surface: AppPalette.background,
      onPrimary: AppPalette.background,
      onSecondary: AppPalette.text,
      onSurface: AppPalette.text,
    ),
    iconTheme: IconThemeData(color: AppPalette.text, opacity: 0.8, size: 24),
  );
}
