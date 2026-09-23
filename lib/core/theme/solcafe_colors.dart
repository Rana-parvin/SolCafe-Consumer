import 'package:flutter/material.dart';

/// Semantic design tokens for SolCafe, representing UI roles rather than raw colors.
@immutable
class SolCafeColors extends ThemeExtension<SolCafeColors> {
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color cardBackground;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnAccent;
  final Color accentGold;
  final Color accentGoldSubtle;
  final Color borderSubtle;
  final Color borderFocused;
  final Color statusPendingBackground;
  final Color statusPendingText;
  final Color statusCompletedBackground;
  final Color statusCompletedText;
  final Color statusCancelledBackground;
  final Color statusCancelledText;
  final Color navBarBackground;
  final Color navBarSelected;
  final Color navBarUnselected;
  final Color drawerBackground;
  final Color drawerHeaderBackground;

  const SolCafeColors({
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.cardBackground,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnAccent,
    required this.accentGold,
    required this.accentGoldSubtle,
    required this.borderSubtle,
    required this.borderFocused,
    required this.statusPendingBackground,
    required this.statusPendingText,
    required this.statusCompletedBackground,
    required this.statusCompletedText,
    required this.statusCancelledBackground,
    required this.statusCancelledText,
    required this.navBarBackground,
    required this.navBarSelected,
    required this.navBarUnselected,
    required this.drawerBackground,
    required this.drawerHeaderBackground,
  });

  /// Light (Warm Cream) semantic palette
  static const SolCafeColors light = SolCafeColors(
    surfacePrimary: Color(0xFFF9F6F0),
    surfaceSecondary: Color(0xFFEFE8DD),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE5D8C5),
    textPrimary: Color(0xFF2D1B14),
    textSecondary: Color(0xFF6F5347),
    textMuted: Color(0xFFA0897C),
    textOnAccent: Color(0xFFFFFFFF),
    accentGold: Color(0xFFC68B27),
    accentGoldSubtle: Color(0xFFFFF7E6),
    borderSubtle: Color(0xFFE0D2C0),
    borderFocused: Color(0xFF8C5A3C),
    statusPendingBackground: Color(0xFFFFF3CD),
    statusPendingText: Color(0xFF856404),
    statusCompletedBackground: Color(0xFFD4EDDA),
    statusCompletedText: Color(0xFF155724),
    statusCancelledBackground: Color(0xFFF8D7DA),
    statusCancelledText: Color(0xFF721C24),
    navBarBackground: Color(0xFFF6F0E6),
    navBarSelected: Color(0xFF5C3A21),
    navBarUnselected: Color(0xFFA0897C),
    drawerBackground: Color(0xFFF5EFE6),
    drawerHeaderBackground: Color(0xFFE8DCCB),
  );

  /// Dark (Rich Brown) semantic palette
  static const SolCafeColors dark = SolCafeColors(
    surfacePrimary: Color(0xFF1B110A),
    surfaceSecondary: Color(0xFF261810),
    cardBackground: Color(0xFF2A1B13),
    cardBorder: Color(0xFF3E2A1E),
    textPrimary: Color(0xFFF5E1C0),
    textSecondary: Color(0xFFD8BEB4),
    textMuted: Color(0xFF9E8478),
    textOnAccent: Color(0xFF1C120C),
    accentGold: Color(0xFFE5B25D),
    accentGoldSubtle: Color(0xFF382A18),
    borderSubtle: Color(0xFF3D291F),
    borderFocused: Color(0xFFE5B25D),
    statusPendingBackground: Color(0xFF3E3218),
    statusPendingText: Color(0xFFFFE69C),
    statusCompletedBackground: Color(0xFF1D3A24),
    statusCompletedText: Color(0xFFA3E6B1),
    statusCancelledBackground: Color(0xFF3E1F23),
    statusCancelledText: Color(0xFFF8B4B9),
    navBarBackground: Color(0xFF22150D),
    navBarSelected: Color(0xFFE5B25D),
    navBarUnselected: Color(0xFF8D766A),
    drawerBackground: Color(0xFF22150D),
    drawerHeaderBackground: Color(0xFF170C06),
  );

  @override
  SolCafeColors copyWith({
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? cardBackground,
    Color? cardBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOnAccent,
    Color? accentGold,
    Color? accentGoldSubtle,
    Color? borderSubtle,
    Color? borderFocused,
    Color? statusPendingBackground,
    Color? statusPendingText,
    Color? statusCompletedBackground,
    Color? statusCompletedText,
    Color? statusCancelledBackground,
    Color? statusCancelledText,
    Color? navBarBackground,
    Color? navBarSelected,
    Color? navBarUnselected,
    Color? drawerBackground,
    Color? drawerHeaderBackground,
  }) {
    return SolCafeColors(
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      accentGold: accentGold ?? this.accentGold,
      accentGoldSubtle: accentGoldSubtle ?? this.accentGoldSubtle,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderFocused: borderFocused ?? this.borderFocused,
      statusPendingBackground: statusPendingBackground ?? this.statusPendingBackground,
      statusPendingText: statusPendingText ?? this.statusPendingText,
      statusCompletedBackground: statusCompletedBackground ?? this.statusCompletedBackground,
      statusCompletedText: statusCompletedText ?? this.statusCompletedText,
      statusCancelledBackground: statusCancelledBackground ?? this.statusCancelledBackground,
      statusCancelledText: statusCancelledText ?? this.statusCancelledText,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      navBarSelected: navBarSelected ?? this.navBarSelected,
      navBarUnselected: navBarUnselected ?? this.navBarUnselected,
      drawerBackground: drawerBackground ?? this.drawerBackground,
      drawerHeaderBackground: drawerHeaderBackground ?? this.drawerHeaderBackground,
    );
  }

  @override
  SolCafeColors lerp(ThemeExtension<SolCafeColors>? other, double t) {
    if (other is! SolCafeColors) return this;
    return SolCafeColors(
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(surfaceSecondary, other.surfaceSecondary, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      accentGoldSubtle: Color.lerp(accentGoldSubtle, other.accentGoldSubtle, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderFocused: Color.lerp(borderFocused, other.borderFocused, t)!,
      statusPendingBackground: Color.lerp(statusPendingBackground, other.statusPendingBackground, t)!,
      statusPendingText: Color.lerp(statusPendingText, other.statusPendingText, t)!,
      statusCompletedBackground: Color.lerp(statusCompletedBackground, other.statusCompletedBackground, t)!,
      statusCompletedText: Color.lerp(statusCompletedText, other.statusCompletedText, t)!,
      statusCancelledBackground: Color.lerp(statusCancelledBackground, other.statusCancelledBackground, t)!,
      statusCancelledText: Color.lerp(statusCancelledText, other.statusCancelledText, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      navBarSelected: Color.lerp(navBarSelected, other.navBarSelected, t)!,
      navBarUnselected: Color.lerp(navBarUnselected, other.navBarUnselected, t)!,
      drawerBackground: Color.lerp(drawerBackground, other.drawerBackground, t)!,
      drawerHeaderBackground: Color.lerp(drawerHeaderBackground, other.drawerHeaderBackground, t)!,
    );
  }
}

/// Extension for convenient access to [SolCafeColors] from [BuildContext].
extension SolCafeColorsBuildContextX on BuildContext {
  SolCafeColors get solcafeColors {
    return Theme.of(this).extension<SolCafeColors>() ?? SolCafeColors.light;
  }
}
