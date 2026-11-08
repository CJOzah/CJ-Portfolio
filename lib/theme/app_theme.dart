import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette: navy with one copper accent (matches the CJ logo).
class Brand {
  static const Color navy = Color(0xFF12263F);
  static const Color ink = Color(0xFF0B1826);
  static const Color inkSurface = Color(0xFF13263A);
  static const Color copper = Color(0xFFD08A4E);
  static const Color text = Color(0xFF16202C);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggle() {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppTheme {
  static final dark = _build(
    brightness: Brightness.dark,
    background: Brand.ink,
    surface: Brand.inkSurface,
    onSurface: const Color(0xFFF2F4F7),
  );

  static final light = _build(
    brightness: Brightness.light,
    background: Colors.white,
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
    final display = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    final textTheme = body
        .copyWith(
          displayLarge: display.displayLarge,
          displayMedium: display.displayMedium,
          displaySmall: display.displaySmall,
          headlineLarge: display.headlineLarge,
          headlineMedium: display.headlineMedium,
          headlineSmall: display.headlineSmall,
          titleLarge: display.titleLarge,
          // Material's default tracking on small text reads as oddly spaced in Inter.
          bodyLarge: body.bodyLarge!.copyWith(letterSpacing: 0),
          bodyMedium: body.bodyMedium!.copyWith(letterSpacing: 0),
          bodySmall: body.bodySmall!.copyWith(letterSpacing: 0),
          titleMedium: body.titleMedium!.copyWith(letterSpacing: 0),
          titleSmall: body.titleSmall!.copyWith(letterSpacing: 0),
          labelLarge: body.labelLarge!.copyWith(letterSpacing: 0),
          labelMedium: body.labelMedium!.copyWith(letterSpacing: 0.1),
          labelSmall: body.labelSmall!.copyWith(letterSpacing: 0.1),
        )
        .apply(bodyColor: onSurface, displayColor: onSurface);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: onSurface.withValues(alpha: 0.16)),
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Brand.navy,
        brightness: brightness,
        primary: onSurface,
        secondary: Brand.copper,
        surface: surface,
        onSurface: onSurface,
      ),
      textTheme: textTheme,
      dividerColor: onSurface.withValues(alpha: 0.12),
      iconTheme: IconThemeData(color: onSurface),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: onSurface,
        selectionColor: Brand.copper.withValues(alpha: 0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.55)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: BorderSide(color: onSurface, width: 1.5)),
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

  /// Accent for text: the logo copper alone is too faint on white.
  Color get accentText => isDark ? Brand.copper : const Color(0xFF9A4F1C);

  /// Background for alternating page bands.
  Color get bandColor => isDark ? const Color(0xFF0F2031) : const Color(0xFFF5F7FA);
}
