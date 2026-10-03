import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Folk Festive Colors
  static const Color festiveGreen = Color(0xFF0E7A3D);
  static const Color festiveGreenLight = Color(0xFF13964C);
  static const Color festiveGreenDark = Color(0xFF0A582C);

  static const Color festiveAmber = Color(0xFFFF7A00);
  static const Color festiveAmberDark = Color(0xFFF37021);
  static const Color festiveAmberLight = Color(0xFFFF9E40);

  static const Color festiveYellow = Color(0xFFFFC107);
  static const Color festiveYellowLight = Color(0xFFFFE082);
  static const Color festiveYellowWarm = Color(0xFFFFB703);

  static const Color canvasCream = Color(0xFFFFFDEE);
  static const Color canvasCreamSecondary = Color(0xFFFAF7EE);

  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color crimsonRed = Color(0xFFE53935);
  static const Color crimsonRedLight = Color(0xFFFFEBEE);

  static const Color textDark = Color(0xFF1A201C);
  static const Color textMuted = Color(0xFF607268);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color borderSubtle = Color(0xFFE0D8C3);

  // Reusable Box Decorations
  static BoxDecoration folkCardDecoration({
    Color backgroundColor = cardBackground,
    Color borderColor = festiveAmber,
    double borderWidth = 2.0,
    double borderRadius = 16.0,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: festiveAmberDark.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration shoutboxDecoration = BoxDecoration(
    color: const Color(0xFFFFF9E6),
    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(
      color: festiveYellowWarm,
      width: 2.0,
    ),
    boxShadow: [
      BoxShadow(
        color: festiveYellowWarm.withValues(alpha: 0.18),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration badgeDecoration({required bool isOnAir}) {
    return BoxDecoration(
      color: isOnAir ? festiveGreen : crimsonRed,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: (isOnAir ? festiveGreen : crimsonRed).withValues(alpha: 0.35),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Material Theme Data
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.hindSiliguriTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvasCream,
      colorScheme: const ColorScheme.light(
        primary: festiveGreen,
        secondary: festiveAmber,
        tertiary: festiveYellow,
        surface: cardBackground,
        error: crimsonRed,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: festiveGreen,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.hindSiliguri(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.hindSiliguri(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: GoogleFonts.hindSiliguri(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.hindSiliguri(
          fontSize: 16,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.hindSiliguri(
          fontSize: 14,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.hindSiliguri(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
      ),
    );
  }
}
