import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/theme%20management/themes.dart';

class ThemeNotifierLegacy extends Notifier<ThemeData> {
  @override
  ThemeData build() => brownTheme;

  void setTheme(ThemeData newTheme) => state = newTheme;
}

final themeProvider = NotifierProvider<ThemeNotifierLegacy, ThemeData>(ThemeNotifierLegacy.new);





