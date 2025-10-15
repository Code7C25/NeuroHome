import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6EE7B7),
      Color(0xFF3B82F6),
      Color(0xFFF472B6),
    ],
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B82F6),
      primary: const Color(0xFF3B82F6),
      secondary: const Color(0xFFF472B6),
      background: const Color(0xFFF0F9FF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F9FF),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3B82F6),
      foregroundColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF3B82F6),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark();
}