import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Apple Monochrome Design Tokens
  static const Color pitchBlack = Color(0xFF0A0A0A);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhiteSurface = Color(0xFFF9F9FB);
  static const Color surfaceContainerLow = Color(0xFFF3F3F5);
  static const Color surfaceContainer = Color(0xFFEDEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE8E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E4);
  
  static const Color slateGray = Color(0xFF666666);
  static const Color ashGray = Color(0xFFA1A1A6);
  static const Color paleHairline = Color(0xFFE5E5EA);

  // Diagnostic Risk Monochrome Tokens
  static const Color riskLowBg = Color(0xFFFFFFFF);
  static const Color riskLowStroke = Color(0xFF111111);
  static const Color riskLowText = Color(0xFF111111);

  static const Color riskMildBg = Color(0xFFE5E5EA);
  static const Color riskMildText = Color(0xFF111111);

  static const Color riskModerateBg = Color(0xFF555555);
  static const Color riskModerateText = Color(0xFFFFFFFF);

  static const Color riskElevatedBg = Color(0xFF111111);
  static const Color riskElevatedText = Color(0xFFFFFFFF);

  // Dark Mode Tokens
  static const Color darkBackground = Color(0xFF121214);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkSurfaceContainer = Color(0xFF2C2C2E);
  static const Color darkHairline = Color(0xFF38383A);

  static ThemeData getLightTheme({required bool highContrast, required double textScaleFactor}) {
    final baseColorScheme = ColorScheme.light(
      primary: pitchBlack,
      onPrimary: pureWhite,
      secondary: slateGray,
      onSecondary: pureWhite,
      surface: offWhiteSurface,
      onSurface: pitchBlack,
      surfaceContainerLowest: pureWhite,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      outline: ashGray,
      outlineVariant: paleHairline,
    );

    return _buildMonochromeTheme(baseColorScheme, textScaleFactor, isDark: false, highContrast: highContrast);
  }

  static ThemeData getDarkTheme({required bool highContrast, required double textScaleFactor}) {
    final baseColorScheme = ColorScheme.dark(
      primary: pureWhite,
      onPrimary: pitchBlack,
      secondary: ashGray,
      onSecondary: pitchBlack,
      surface: darkBackground,
      onSurface: pureWhite,
      surfaceContainerLowest: darkSurface,
      surfaceContainerLow: darkSurfaceContainer,
      surfaceContainer: darkSurfaceContainer,
      outline: ashGray,
      outlineVariant: darkHairline,
    );

    return _buildMonochromeTheme(baseColorScheme, textScaleFactor, isDark: true, highContrast: highContrast);
  }

  static ThemeData _buildMonochromeTheme(ColorScheme colorScheme, double textScaleFactor, {required bool isDark, required bool highContrast}) {
    final baseText = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    
    // Apple HIG Typography with Manrope for Headlines & Hanken Grotesk for Body
    final textTheme = GoogleFonts.hankenGroteskTextTheme(baseText).copyWith(
      displayLarge: GoogleFonts.manrope(
        fontSize: 36 * textScaleFactor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.2,
        color: colorScheme.onSurface,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontSize: 28 * textScaleFactor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 22 * textScaleFactor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.3,
        color: colorScheme.onSurface,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 18 * textScaleFactor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.35,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.hankenGrotesk(
        fontSize: 16 * textScaleFactor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.hankenGrotesk(
        fontSize: 16 * textScaleFactor,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.hankenGrotesk(
        fontSize: 14 * textScaleFactor,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: isDark ? ashGray : slateGray,
      ),
      bodySmall: GoogleFonts.hankenGrotesk(
        fontSize: 12 * textScaleFactor,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: ashGray,
      ),
      labelLarge: GoogleFonts.hankenGrotesk(
        fontSize: 14 * textScaleFactor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: colorScheme.onPrimary,
      ),
      labelSmall: GoogleFonts.hankenGrotesk(
        fontSize: 11 * textScaleFactor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: isDark ? ashGray : slateGray,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? darkBackground : offWhiteSurface,
      textTheme: textTheme,
      
      // Zero elevation card style with 0.5px hairline border
      cardTheme: CardThemeData(
        color: isDark ? darkSurface : pureWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? darkHairline : paleHairline,
            width: highContrast ? 1.5 : 0.5,
          ),
        ),
      ),

      // AppBar HIG Translucent style
      appBarTheme: AppBarTheme(
        backgroundColor: (isDark ? darkBackground : offWhiteSurface).withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 18 * textScaleFactor,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Tactile Pill Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? pureWhite : pitchBlack,
          foregroundColor: isDark ? pitchBlack : pureWhite,
          elevation: 0,
          minimumSize: const Size(120, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: GoogleFonts.hankenGrotesk(
            fontSize: 15 * textScaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: isDark ? darkSurface : pureWhite,
          side: BorderSide(
            color: isDark ? darkHairline : paleHairline,
            width: highContrast ? 1.5 : 0.5,
          ),
          minimumSize: const Size(120, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: GoogleFonts.hankenGrotesk(
            fontSize: 15 * textScaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkSurface : pureWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? darkHairline : paleHairline, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? darkHairline : paleHairline, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? pureWhite : pitchBlack, width: 1.5),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? darkHairline : paleHairline,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  // Diagnostic Risk Level Badge Helpers
  static Widget buildRiskBadge(String riskLevel) {
    final normRisk = riskLevel.trim().toLowerCase();
    Color bg;
    Color fg;
    Border? border;

    if (normRisk == 'none' || normRisk == 'baseline' || normRisk == 'low') {
      bg = riskLowBg;
      fg = riskLowText;
      border = Border.all(color: riskLowStroke, width: 1);
    } else if (normRisk == 'mild') {
      bg = riskMildBg;
      fg = riskMildText;
      border = null;
    } else if (normRisk == 'moderate') {
      bg = riskModerateBg;
      fg = riskModerateText;
      border = null;
    } else {
      // Elevated / Priority
      bg = riskElevatedBg;
      fg = riskElevatedText;
      border = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: border,
      ),
      child: Text(
        riskLevel.toUpperCase(),
        style: GoogleFonts.hankenGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
