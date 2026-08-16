import 'package:flutter/material.dart';

final ThemeData brownTheme = ThemeData(
  useMaterial3: false,
  toggleButtonsTheme: const ToggleButtonsThemeData(
    disabledColor: Color(0xFFD8BEB4),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3B2522),
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF795548), // Drawer background
    primary: Color(0xFF3E2C26),
    secondary: Color(0xFFF5E1C0),
    tertiary: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF3B2522),
  ),
  cardColor: const Color(0xFF382116),
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF301F19),
  scaffoldBackgroundColor: const Color(0xFF553D34),
  iconTheme: const IconThemeData(
    color: Color(0xFFF5E1C0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Color(0xFF3B1B10)),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFFDAA520)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.amber),
    ),
  ),
  textTheme: const TextTheme(
    labelMedium: TextStyle(color: Color(0xFF3E2723)),
    bodyLarge: TextStyle(color: Color(0xFFF5E1C0)),
    bodyMedium: TextStyle(color: Color(0xFFFFF8E1)),
  ),
);

final ThemeData creamTheme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.brown[700],
    unselectedItemColor: Colors.brown,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(color: Color(0xFFF5E1C0), fontSize: 18),
    backgroundColor: Color(0xFF3B2522),
    iconTheme: IconThemeData(color: Color(0xFFD8C7C7)),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.brown[800],
  ),
  colorScheme: const ColorScheme.light(
    surface: Colors.white, // Drawer background
    onSurface: Colors.black, // Drawer header color
    primary: Color(0xFFF5E1C0),
    secondary: Color(0xFF3E2723),
  ),
  cardColor: const Color(0xFFF5E1C0),
  brightness: Brightness.light,
  primaryColor: const Color(0xFFF5E1C0),
  scaffoldBackgroundColor: const Color(0xFFF5E1C0),
  iconTheme: const IconThemeData(color: Color(0xFF6F4E37)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Color(0xFFFFF8E1)),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFF3E2723)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.amber),
    ),
  ),
  textTheme: const TextTheme(
    labelMedium: TextStyle(color: Color(0xFFF5E1C0)),
    bodyLarge: TextStyle(color: Color(0xFF3E2723)),
    bodyMedium: TextStyle(color: Color(0xFF3E2723)),
  ),
);
