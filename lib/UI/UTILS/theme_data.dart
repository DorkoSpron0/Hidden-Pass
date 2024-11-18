import 'package:flutter/material.dart';

ThemeData customThemeData() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Onest',
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF23232F),
        onPrimary: Colors.white,
        secondary: Color(0xff5D5D5D),
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Color(0xFF23232F),
        onSurface: Colors.white),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
