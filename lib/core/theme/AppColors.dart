// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {

  // ── Primary Brand ────────────────────────
  static const Color primary     = Color(0xFF0F2D52);
  static const Color primaryLight= Color(0xFF1A4A7A);
  static const Color accent      = Color(0xFF00C2CB);
  static const Color accentLight = Color(0xFF80E5E9);

  // ── Background ───────────────────────────
  static const Color background  = Color(0xFFF5F7FA);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surfaceAlt  = Color(0xFFF0F4FF);

  // ── Text ─────────────────────────────────
  static const Color textPrimary = Color(0xFF0F2D52);
  static const Color textSecondary= Color(0xFF6B7C93);
  static const Color textHint    = Color(0xFFADB9C9);

  // ── Status ───────────────────────────────
  static const Color success     = Color(0xFF00B37E);
  static const Color error       = Color(0xFFFF4D4F);
  static const Color warning     = Color(0xFFFFAD14);

  // ── Border ───────────────────────────────
  static const Color border      = Color(0xFFE1E8F0);
  static const Color borderFocus = Color(0xFF00C2CB);

  // ── Gradient ─────────────────────────────
  static const LinearGradient primaryGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F2D52), Color(0xFF1A6B8A)],
  );

  static const LinearGradient accentGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C2CB), Color(0xFF0072FF)],
  );
}
