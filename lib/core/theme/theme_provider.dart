import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/theme/app_theme.dart';

class ThemeNotifier extends Notifier<ThemeData> {
  @override
  ThemeData build() => brownTheme;

  void setTheme(ThemeData newTheme) => state = newTheme;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeData>(ThemeNotifier.new);





