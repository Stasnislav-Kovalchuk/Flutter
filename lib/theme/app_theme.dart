import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF080B10),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF11151C),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardColor: const Color(0xFF151A24),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF151A24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF151A24),
        selectedColor: colorScheme.primary,
        labelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
