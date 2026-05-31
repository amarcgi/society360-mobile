// lib/core/theme/app_spacing.dart
// ✅ Consistent spacing throughout the app
// ── Gap widget shorthand ─────────────────────
// Use instead of SizedBox(height: 16)
import 'package:flutter/material.dart';
class AppSpacing {
  // Base unit = 4px
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 20.0;
  static const double xxl = 24.0;
  static const double xxxl= 32.0;
  static const double huge= 48.0;

  // Screen padding
  static const double screenPadding = 20.0;

  // Card padding
  static const double cardPadding = 16.0;
}



class Gap extends StatelessWidget {
  final double size;
  final bool horizontal;

  const Gap(this.size, {
    super.key,
    this.horizontal = false,
  });

  const Gap.h(this.size, {super.key})
      : horizontal = true;

  @override
  Widget build(BuildContext context) =>
      horizontal
          ? SizedBox(width: size)
          : SizedBox(height: size);
}

// Usage:
// Gap(16)           ← vertical 16px
// Gap.h(8)          ← horizontal 8px
// Gap(AppSpacing.lg) ← using constant
