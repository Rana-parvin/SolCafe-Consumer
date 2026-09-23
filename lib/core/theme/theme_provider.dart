import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/core/theme/app_theme.dart';


enum SolCafeThemeMode { cream, brown, system }

const String kThemePrefKey = 'solcafe_theme_mode';

class ThemeNotifier extends Notifier<SolCafeThemeMode> {
  @override
  SolCafeThemeMode build() {
    _loadPersistedTheme();
    return SolCafeThemeMode.brown; // Default initial state
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(kThemePrefKey);
      if (savedMode != null) {
        final mode = SolCafeThemeMode.values.firstWhere(
          (e) => e.name == savedMode,
          orElse: () => SolCafeThemeMode.brown,
        );
        state = mode;
      }
    } catch (_) {
      // Fallback gracefully to brown default
    }
  }

  Future<void> setThemeMode(SolCafeThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kThemePrefKey, mode.name);
    } catch (_) {}
  }

  Future<void> toggleTheme() async {
    final nextMode = state == SolCafeThemeMode.cream
        ? SolCafeThemeMode.brown
        : SolCafeThemeMode.cream;
    await setThemeMode(nextMode);
  }
}

final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, SolCafeThemeMode>(ThemeNotifier.new);

/// Helper extension to map SolCafeThemeMode to Flutter ThemeMode
extension SolCafeThemeModeX on SolCafeThemeMode {
  ThemeMode get flutterThemeMode {
    switch (this) {
      case SolCafeThemeMode.cream:
        return ThemeMode.light;
      case SolCafeThemeMode.brown:
        return ThemeMode.dark;
      case SolCafeThemeMode.system:
        return ThemeMode.system;
    }
  }

  bool isLight(BuildContext context) {
    if (this == SolCafeThemeMode.cream) return true;
    if (this == SolCafeThemeMode.brown) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.light;
  }
}

// Backward compatibility alias for existing callers watching themeProvider
final themeProvider = Provider<ThemeData>((ref) {
  // Return current active ThemeData based on selected mode
  final mode = ref.watch(themeNotifierProvider);
  if (mode == SolCafeThemeMode.cream) {
    return creamTheme;
  }
  return brownTheme;
});
