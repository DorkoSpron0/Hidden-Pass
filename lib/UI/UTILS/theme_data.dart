import 'package:flutter/material.dart';

ThemeData customThemeData({required bool isDarkMode}) {
  final baseColorScheme = isDarkMode
      ? const ColorScheme.dark(
    primary: Color(0XFF131313),
    onPrimary: Colors.white,
    secondary: Color(0xff5D5D5D),
    onSecondary: Colors.white,
    tertiary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0XFF242424),
    onSurface: Colors.white,
  )
      : const ColorScheme.light(
    primary: Color(0xFFf2f2f2),
    onPrimary: Colors.black,
    secondary: Color(0xff5D5D5D),
    onSecondary: Colors.black,
    tertiary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  return ThemeData(
    fontFamily: 'Onest',
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: baseColorScheme.surface,
      iconTheme: IconThemeData(color: baseColorScheme.onSurface),
      titleTextStyle: TextStyle(
        color: baseColorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    colorScheme: baseColorScheme,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: baseColorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: baseColorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: baseColorScheme.secondary,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: baseColorScheme.secondary,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}
