import 'package:flutter/material.dart';

ThemeData customThemeData() {
  return ThemeData(
    fontFamily: 'Onest',
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0XFF242424),
    ),
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF23232F),
        onPrimary: Colors.white,
        secondary: Color(0xff5D5D5D),
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Color(0XFF242424),
        onSurface: Colors.white),
    textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          decoration: TextDecoration.underline
        )),
  );
}
