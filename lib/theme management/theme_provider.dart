import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:solcafe/theme%20management/themes.dart';
final themeProvider = StateProvider<ThemeData>((ref) => brownTheme);
