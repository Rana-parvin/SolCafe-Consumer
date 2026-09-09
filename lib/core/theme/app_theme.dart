import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

final ThemeData creamTheme = _buildTheme(
  brightness: Brightness.light,
  tokens: SolCafeColors.light,
);

final ThemeData brownTheme = _buildTheme(
  brightness: Brightness.dark,
  tokens: SolCafeColors.dark,
);

ThemeData _buildTheme({
  required Brightness brightness,
  required SolCafeColors tokens,
}) {
  final isDark = brightness == Brightness.dark;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: tokens.accentGold,
    onPrimary: tokens.textOnAccent,
    primaryContainer: tokens.surfaceSecondary,
    onPrimaryContainer: tokens.textPrimary,
    secondary: tokens.accentGold,
    onSecondary: tokens.textOnAccent,
    surface: tokens.cardBackground,
    onSurface: tokens.textPrimary,
    onSurfaceVariant: tokens.textSecondary,
    outline: tokens.borderSubtle,
    error: tokens.statusCancelledText,
    onError: Colors.white,
  );

  final textTheme = TextTheme(
    headlineLarge: GoogleFonts.readexPro(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: tokens.textPrimary,
    ),
    headlineMedium: GoogleFonts.readexPro(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: tokens.textPrimary,
    ),
    titleLarge: GoogleFonts.readexPro(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: tokens.textPrimary,
    ),
    titleMedium: GoogleFonts.readexPro(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: tokens.textPrimary,
    ),
    titleSmall: GoogleFonts.readexPro(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: tokens.textSecondary,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: tokens.textPrimary,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: tokens.textPrimary,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: tokens.textSecondary,
    ),
    labelLarge: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: tokens.textPrimary,
    ),
    labelMedium: GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: tokens.textSecondary,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: tokens.surfacePrimary,
    cardColor: tokens.cardBackground,
    primaryColor: tokens.accentGold,
    extensions: [tokens],
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: tokens.surfacePrimary,
      foregroundColor: tokens.textPrimary,
      iconTheme: IconThemeData(color: tokens.textPrimary),
      titleTextStyle: GoogleFonts.readexPro(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: tokens.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: tokens.cardBackground,
      elevation: isDark ? 1 : 2,
      shadowColor: isDark ? Colors.black38 : const Color(0x1F000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: tokens.cardBorder, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: tokens.textOnAccent,
        backgroundColor: tokens.accentGold,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: tokens.textPrimary,
        side: BorderSide(color: tokens.borderSubtle, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tokens.accentGold,
        textStyle: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.surfaceSecondary,
      hintStyle: GoogleFonts.openSans(
        color: tokens.textMuted,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.openSans(
        color: tokens.textSecondary,
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tokens.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tokens.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tokens.borderFocused, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tokens.statusCancelledText),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: tokens.navBarBackground,
      selectedItemColor: tokens.navBarSelected,
      unselectedItemColor: tokens.navBarUnselected,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: tokens.cardBackground,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: tokens.cardBorder),
      ),
      titleTextStyle: GoogleFonts.readexPro(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: tokens.textPrimary,
      ),
      contentTextStyle: GoogleFonts.openSans(
        fontSize: 14,
        color: tokens.textPrimary,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: tokens.cardBackground,
      modalBackgroundColor: tokens.cardBackground,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: tokens.borderSubtle,
      thickness: 1,
      space: 1,
    ),
    iconTheme: IconThemeData(
      color: tokens.textPrimary,
      size: 24,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? const Color(0xFF32231A) : const Color(0xFF2D1B14),
      contentTextStyle: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
