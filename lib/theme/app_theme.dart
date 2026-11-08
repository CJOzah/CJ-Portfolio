import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette: deep navy + ember orange (matches the CJ logo).
class Brand {
  static const Color navy = Color(0xFF03273F);
  static const Color ink = Color(0xFF051A2A);
  static const Color inkSurface = Color(0xFF0B2638);
  static const Color orange = Color(0xFFF2842F);
  static const Color amber = Color(0xFFFFC069);
  static const Color ember = Color(0xFFE4572E);
  static const Color paper = Color(0xFFF7F4EE);
  static const Color text = Color(0xFF0E1B26);
  static const Color snow = Color(0xFFF8F9FA);

  static const LinearGradient fire = LinearGradient(
    colors: [amber, orange, ember],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggle() {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: Brand.ink,
        surface: Brand.inkSurface,
        onSurface: Brand.snow,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: Brand.paper,
        surface: Colors.white,
        onSurface: Brand.text,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final body = GoogleFonts.interTextTheme(base.textTheme);
    final display = GoogleFonts.spaceGroteskTextTheme(base.textTheme);
    final textTheme = body
        .copyWith(
          displayLarge: display.displayLarge,
          displayMedium: display.displayMedium,
          displaySmall: display.displaySmall,
          headlineLarge: display.headlineLarge,
          headlineMedium: display.headlineMedium,
          headlineSmall: display.headlineSmall,
          titleLarge: display.titleLarge,
        )
        .apply(bodyColor: onSurface, displayColor: onSurface);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Brand.orange,
        brightness: brightness,
        primary: Brand.orange,
        secondary: Brand.amber,
        surface: surface,
        onSurface: onSurface,
      ),
      textTheme: textTheme,
      dividerColor: onSurface.withValues(alpha: 0.08),
      iconTheme: IconThemeData(color: onSurface),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Brand.orange,
        selectionColor: Brand.orange.withValues(alpha: 0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: onSurface.withValues(alpha: 0.04),
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: onSurface.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: onSurface.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Brand.orange, width: 1.5),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobile => screenWidth < 700;
  bool get isDesktop => screenWidth >= 1100;
  double get gutter => isMobile ? 20 : 40;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
