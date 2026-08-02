import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
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
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF9F9FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF041920),
        secondary: Color(0xFFFD761A),
        surface: Color(0xFFE7EEFF),
        onSurface: Color(0xFF111C2C),
        onSurfaceVariant: Color(0xFF42484A),
        outline: Color(0xFF73787A),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(fontSize: 32, fontWeight: FontWeight.w600, color: const Color(0xFF111C2C)),
        headlineMedium: GoogleFonts.sourceSerif4(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF111C2C)),
        bodyLarge: GoogleFonts.literata(fontSize: 18, fontWeight: FontWeight.w400, color: const Color(0xFF111C2C)),
        bodyMedium: GoogleFonts.literata(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF42484A)),
        labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: const Color(0xFF111C2C)),
      ),
    );
  }
}
