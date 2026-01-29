import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF13C8EC);
  static const Color backgroundLight = Color(0xFFF6F8F8);
  static const Color backgroundDark = Color(0xFF101F22);
  static const Color textLight = Color(0xFF0F172A); // Slate 900
  static const Color textDark = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primary,
        background: backgroundLight,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: textLight,
        displayColor: textLight,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        background: backgroundDark,
        surface: Color(0xFF1A2E32), // Slightly lighter for cards
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      useMaterial3: true,
    );
  }
}
