// Use these everywhere — never hardcode TextStyle

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/AppColors.dart';
class AppTextStyles {

  // ── Display ──────────────────────────────
  static TextStyle displayLarge = GoogleFonts.sora(
    fontSize: 36, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle displayMedium = GoogleFonts.sora(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // ── Headings ─────────────────────────────
  static TextStyle h1 = GoogleFonts.sora(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.sora(
    fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.sora(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.sora(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.sora(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.sora(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Labels ───────────────────────────────
  static TextStyle labelLarge = GoogleFonts.sora(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.sora(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.sora(
    fontSize: 10, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ── Caption ──────────────────────────────
  static TextStyle caption = GoogleFonts.sora(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  // ── Button ───────────────────────────────
  static TextStyle button = GoogleFonts.sora(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // ── Helper: colored variant ───────────────
  static TextStyle colored(
      TextStyle base, Color color) =>
      base.copyWith(color: color);
}
