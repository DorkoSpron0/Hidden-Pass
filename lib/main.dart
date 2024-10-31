import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/home_screen.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: customThemeData(),
    );
  }
}
