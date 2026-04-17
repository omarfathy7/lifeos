import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  // ── Orbitron (Large Titles Only) ──
  static TextStyle orbitronLarge = const TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
  );

  static TextStyle orbitronMedium = const TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  static TextStyle orbitronSmall = const TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 2,
  );

  // ── Inter (All Regular Text) ──
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  // ── Saga (AI Story) ──
  static TextStyle sagaText = GoogleFonts.ibmPlexSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.8,
    fontStyle: FontStyle.italic,
  );
}
