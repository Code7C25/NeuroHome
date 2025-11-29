import 'package:flutter/material.dart';

class AppTheme {
  // Gradiente Hero mejorado
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo más vibrante
      Color(0xFF8B5CF6), // Violet
      Color(0xFFEC4899), // Pink
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Nuevo gradiente para fondos oscuros
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A), // Azul muy oscuro
      Color(0xFF1E293B), // Azul oscuro
      Color(0xFF334155), // Gris azulado
    ],
  );

  // Colores para el tema oscuro
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkAccent = Color(0xFF6366F1);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFFEC4899),
      background: const Color(0xFFF0F9FF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F9FF),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6366F1),
      foregroundColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF6366F1),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: darkAccent,
      secondary: Color(0xFFEC4899),
      surface: darkSurface,
      background: Color(0xFF0F172A),
      onBackground: darkTextPrimary,
      onSurface: darkTextPrimary,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkAccent,
      foregroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: darkTextPrimary,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkTextSecondary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkTextSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkSurface),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkAccent, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkSurface,
      indicatorColor: darkAccent,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(color: darkTextSecondary),
      ),
    ),
  );

  // Método helper para aplicar gradientes a containers
  static BoxDecoration getDarkGradientDecoration() {
    return const BoxDecoration(
      gradient: darkBackgroundGradient,
    );
  }

  // Sombras modernas
  static List<BoxShadow> getCardShadows(bool isDark) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
        blurRadius: 15,
        offset: const Offset(0, 4),
      ),
    ];
  }
}