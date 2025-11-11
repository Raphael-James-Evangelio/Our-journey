import 'package:flutter/material.dart';

class Palette {
  static const Color blush = Color(0xFFB87C7C);
  static const Color blushDark = Color(0xFF8B4A4A);
  static const Color blushLight = Color(0xFFF3E4E4);
  static const Color ivory = Color(0xFFFFF8F3);
  static const Color midnight = Color(0xFF1F1825);
  static const Color sand = Color(0xFFEBD7C8);

  static LinearGradient radialBlushGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFF3F0),
        Color(0xFFFBE4E5),
        Color(0xFFF2D7D9),
      ],
    );
  }

  static LinearGradient blushSweepGradient() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFF7F2),
        Color(0xFFF7E2DF),
        Color(0xFFEED7D6),
      ],
    );
  }
}

