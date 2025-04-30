import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'ComicNeue',
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.indigo.shade400,
      secondary: Colors.orange.shade300,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: Colors.grey.shade100,
    textTheme: TextTheme(
      headlineLarge: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.deepPurple,
        letterSpacing: -0.5,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.deepPurple,
        letterSpacing: -0.5,
      ),
      headlineSmall: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.3,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.3,
      ),
      bodySmall: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: -0.3,
      ),
      labelMedium: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    iconTheme: IconThemeData(size: 28, color: Colors.indigo.shade400),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo.shade400,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 28),
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
  );
}
