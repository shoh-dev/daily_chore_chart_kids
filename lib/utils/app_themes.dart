import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
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
      headlineLarge: GoogleFonts.fredoka(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
      headlineSmall: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black87),
      bodyMedium: GoogleFonts.comicNeue(fontSize: 14, color: Colors.black54),
      bodySmall: GoogleFonts.comicNeue(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.comicNeue(
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
      titleTextStyle: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
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
