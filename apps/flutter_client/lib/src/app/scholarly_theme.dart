import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_tokens.dart';

class ScholarlyTheme {
  static const Color primary = Color(0xFF1A2E35);
  static const Color secondary = Color(0xFFFD761A);
  static const Color background = Color(0xFF0F141C);
  static const Color surfaceContainer = Color(0xFF1A202C);
  static const Color surfaceContainerHigh = Color(0xFF242C3D);
  static const Color onSurface = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);
  static const Color outline = Color(0xFF42484A);
  static const Color orpHighlight = Color(0xFFFD761A);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceContainer,
        surfaceContainerHighest: surfaceContainerHigh,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
      ),
      cardTheme: CardThemeData(
        elevation: AppTokens.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(fontSize: 32, fontWeight: FontWeight.w600, color: onSurface),
        headlineMedium: GoogleFonts.sourceSerif4(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
        bodyLarge: GoogleFonts.literata(fontSize: 18, fontWeight: FontWeight.w400, color: onSurface),
        bodyMedium: GoogleFonts.literata(fontSize: 16, fontWeight: FontWeight.w400, color: onSurfaceVariant),
        labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: onSurface),
      ),
    );
  }

  static ThemeData light() {
    const lightBg = Color(0xFFF6F8FC);
    const lightSurface = Color(0xFFFFFFFF);
    const lightSurfaceContainer = Color(0xFFF1F5F9);
    const lightOnSurface = Color(0xFF0F172A);
    const lightOnSurfaceVariant = Color(0xFF64748B);
    const lightOutline = Color(0xFFE2E8F0);
    const lightPrimary = Color(0xFF4F46E5);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: secondary,
        surface: lightSurface,
        surfaceContainer: lightSurfaceContainer,
        surfaceContainerHighest: Color(0xFFEAEFF8),
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
        outline: lightOutline,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: lightOnSurface,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: lightOnSurface,
          letterSpacing: -0.3,
        ),
        shape: const Border(
          bottom: BorderSide(color: lightOutline, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: AppTokens.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          side: const BorderSide(color: lightOutline, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(fontSize: 32, fontWeight: FontWeight.w600, color: lightOnSurface),
        headlineMedium: GoogleFonts.sourceSerif4(fontSize: 24, fontWeight: FontWeight.w600, color: lightOnSurface),
        bodyLarge: GoogleFonts.literata(fontSize: 18, fontWeight: FontWeight.w400, color: lightOnSurface),
        bodyMedium: GoogleFonts.literata(fontSize: 16, fontWeight: FontWeight.w400, color: lightOnSurfaceVariant),
        labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: lightOnSurface),
      ),
    );
  }
}
