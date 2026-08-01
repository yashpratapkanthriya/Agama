import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgamaTheme {
  // ─── Palette ─────────────────────────────────────────────────────────
  // Cool pearl background — instrument precision, not warmth
  static const Color bg = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F8);

  // Ink blue-black — richer than slate-900, cooler than pure black
  static const Color ink = Color(0xFF1C2033);
  static const Color inkMuted = Color(0xFF5A6275);
  static const Color inkFaint = Color(0xFF8C95A8);

  // Borders — hairline precision
  static const Color border = Color(0xFFE4E7EF);
  static const Color borderStrong = Color(0xFFC8CEDE);

  // Accents — each with a specific role, never decorative
  static const Color indigo = Color(0xFF4F46E5); // primary action
  static const Color indigoLight = Color(0xFFEEEDFF); // hover / tint
  static const Color emerald = Color(0xFF059669); // speed / success
  static const Color emeraldLight = Color(0xFFECFDF5);
  static const Color crimson = Color(0xFFEF4444); // ORP anchor only
  static const Color amber = Color(0xFFD97706); // complexity / warning

  // RSVP reading viewport — pure darkness for maximum contrast
  static const Color rsvpBg = Color(0xFF0A0D17);

  // ─── Light Theme ─────────────────────────────────────────────────────
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: indigo,
        primaryContainer: indigoLight,
        secondary: emerald,
        secondaryContainer: emeraldLight,
        surface: surface,
        surfaceContainerHighest: surfaceVariant,
        error: crimson,
        onPrimary: Colors.white,
        onSurface: ink,
        onSurfaceVariant: inkMuted,
        outline: border,
        outlineVariant: borderStrong,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: ink,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.3,
        ),
        shape: const Border(
          bottom: BorderSide(color: border, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: indigo, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: inkFaint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: indigo,
        inactiveTrackColor: border,
        thumbColor: indigo,
        overlayColor: indigo.withAlpha(24),
        trackHeight: 3,
        valueIndicatorColor: ink,
        valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: indigo,
        labelStyle: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: border),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(indigo),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
          textStyle: WidgetStateProperty.all(
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(ink),
          side: WidgetStateProperty.all(const BorderSide(color: border)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
          textStyle: WidgetStateProperty.all(
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      ),
      textTheme: _buildTextTheme(ink, inkMuted),
    );
  }

  // ─── Dark Theme (Sanctuary) ───────────────────────────────────────────
  static const Color darkBg = Color(0xFF0C0F1A);
  static const Color darkSurface = Color(0xFF141825);
  static const Color darkSurfaceVariant = Color(0xFF1C2235);
  static const Color darkInk = Color(0xFFF0F2FA);
  static const Color darkInkMuted = Color(0xFF8A93AB);
  static const Color darkInkFaint = Color(0xFF5A6275);
  static const Color darkBorder = Color(0xFF232A3E);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: indigo,
        primaryContainer: Color(0x2B4F46E5),
        secondary: emerald,
        secondaryContainer: Color(0x22059669),
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        error: crimson,
        onPrimary: Colors.white,
        onSurface: darkInk,
        onSurfaceVariant: darkInkMuted,
        outline: darkBorder,
        outlineVariant: Color(0xFF2E3650),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: darkInk,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: darkInk,
          letterSpacing: -0.3,
        ),
        shape: const Border(
          bottom: BorderSide(color: darkBorder, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: indigo,
        inactiveTrackColor: darkBorder,
        thumbColor: indigo,
        overlayColor: indigo.withAlpha(40),
        trackHeight: 3,
        valueIndicatorColor: darkSurface,
        valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: darkInk,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: indigo,
        labelStyle: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: darkBorder),
      ),
      textTheme: _buildTextTheme(darkInk, darkInkMuted),
    );
  }

  // ─── Text Theme ───────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color main, Color muted) {
    return TextTheme(
      // Display — Outfit bold, tight tracking, large presence
      displayLarge: GoogleFonts.outfit(
        fontSize: 36, fontWeight: FontWeight.w800,
        letterSpacing: -1.0, height: 1.15, color: main,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 28, fontWeight: FontWeight.w700,
        letterSpacing: -0.8, height: 1.2, color: main,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 22, fontWeight: FontWeight.w700,
        letterSpacing: -0.5, height: 1.25, color: main,
      ),
      // Titles — Outfit semibold
      titleLarge: GoogleFonts.outfit(
        fontSize: 18, fontWeight: FontWeight.w700,
        letterSpacing: -0.3, height: 1.3, color: main,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 15, fontWeight: FontWeight.w600,
        letterSpacing: -0.2, height: 1.35, color: main,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 13, fontWeight: FontWeight.w600,
        letterSpacing: 0, height: 1.4, color: main,
      ),
      // Body — Inter, precise legibility
      bodyLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400,
        height: 1.65, color: main,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w400,
        height: 1.55, color: main,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400,
        height: 1.5, color: muted,
      ),
      // Labels / Mono — JetBrains Mono for metrics and data
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 12, fontWeight: FontWeight.w700,
        letterSpacing: 0.6, color: main,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 11, fontWeight: FontWeight.w600,
        letterSpacing: 0.4, color: main,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 10, fontWeight: FontWeight.w500,
        letterSpacing: 0.3, color: muted,
      ),
    );
  }
}
