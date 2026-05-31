// lib/shared/widgets/app_snackbar.dart

import 'package:flutter/material.dart';

import '../../theme/AppColors.dart';
import 'app_text_styles.dart';



class AppSnackbar {

  static void success(
      BuildContext context, String message) {
    _show(context, message,
        AppColors.success,
        Icons.check_circle_outline_rounded);
  }

  static void error(
      BuildContext context, String message) {
    _show(context, message,
        AppColors.error,
        Icons.error_outline_rounded);
  }

  static void warning(
      BuildContext context, String message) {
    _show(context, message,
        AppColors.warning,
        Icons.warning_amber_rounded);
  }

  static void info(
      BuildContext context, String message) {
    _show(context, message,
        AppColors.primary,
        Icons.info_outline_rounded);
  }

  static void _show(
      BuildContext context,
      String message,
      Color color,
      IconData icon,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white,
              size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white)),
          ),
        ]),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration:
        const Duration(seconds: 3),
      ));
  }
}

// ── Usage ────────────────────────────────────
// AppSnackbar.success(context, 'Payment done!');
// AppSnackbar.error(context, 'Invalid OTP');
// AppSnackbar.warning(context, 'Due in 3 days');
// AppSnackbar.info(context, 'Package arrived');