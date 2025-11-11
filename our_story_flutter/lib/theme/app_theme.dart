import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B4A4A),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.playfairDisplayTextTheme(),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFFF8F3),
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      bodyLarge: GoogleFonts.inter(textStyle: base.textTheme.bodyLarge),
      bodyMedium: GoogleFonts.inter(textStyle: base.textTheme.bodyMedium),
      bodySmall: GoogleFonts.inter(textStyle: base.textTheme.bodySmall),
      labelLarge: GoogleFonts.inter(textStyle: base.textTheme.labelLarge),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

