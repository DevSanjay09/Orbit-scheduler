import 'package:flutter/material.dart';

/// Minimalist Black & White luxury aerospace design tokens.
class OrbitTheme {
  // Pure OLED black and deep matte charcoals
  static const Color bgDark = Color(0xFF000000);
  static const Color cardDark = Color(0xFF040405);
  static const Color cardBorder = Color(0xFF18181B);
  static const Color surfaceElevated = Color(0xFF0A0A0C);

  // Pure monochrome whites and silvers
  static const Color white = Color(0xFFFFFFFF);
  static const Color silverLight = Color(0xFFF4F4F6);
  static const Color silver = Color(0xFFD4D4D8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);

  // Refined functional accents (subtle, high-contrast, elegant)
  static const Color cyanAccent = Color(0xFFFFFFFF); // Clean white primary highlight
  static const Color neonGreen = Color(0xFFE4E4E7); // Clean light silver
  static const Color warningAmber = Color(0xFFD4D4D8); // Muted silver
  static const Color dangerRed = Color(0xFFFFFFFF); // High-contrast inverted white
  static const Color laserPurple = Color(0xFFA1A1AA); // Zinc-400
  static const Color blueAccent = Color(0xFFE4E4E7);

  // Status indicators (minimalist, understated)
  static const Color statusOnline = Color(0xFFFFFFFF);
  static const Color statusDegraded = Color(0xFFA1A1AA);
  static const Color statusOffline = Color(0xFF71717A);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: white,
      cardColor: cardDark,
      canvasColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: white,
        secondary: silver,
        surface: cardDark,
        error: white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
      ),
      dividerColor: cardBorder,
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary, letterSpacing: -0.2),
        bodyMedium: TextStyle(color: textSecondary, letterSpacing: -0.1),
      ),
    );
  }

  /// Minimalist card box decoration
  static BoxDecoration glassBox({
    Color color = cardDark,
    Color borderColor = cardBorder,
    double radius = 10.0,
    bool glow = false,
    Color glowColor = white,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 1.0),
      boxShadow: glow
          ? [
              BoxShadow(
                color: white.withValues(alpha: 0.05),
                blurRadius: 12.0,
                spreadRadius: 0.5,
              ),
            ]
          : null,
    );
  }
}
