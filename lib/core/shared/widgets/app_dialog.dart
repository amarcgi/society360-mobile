// lib/shared/widgets/app_dialog.dart

import 'package:flutter/material.dart';

import '../../theme/AppColors.dart';
import 'app_button.dart';
import 'app_text_styles.dart';


class AppDialog {

  // ── 1. Confirm Dialog ─────────────────────
  static Future<bool?> confirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmLabel  = 'Confirm',
        String cancelLabel   = 'Cancel',
        bool isDanger        = false,
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: AppTextStyles.h2),
        content: Text(message,
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: Text(cancelLabel,
              style: AppTextStyles.labelLarge
                  .copyWith(
                  color: AppColors.textSecondary),
            ),
          ),
          AppButton(
            label: confirmLabel,
            fullWidth: false,
            size: AppButtonSize.small,
            variant: isDanger
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: () =>
                Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  // ── 2. Info / Success / Error Dialog ──────
  static Future<void> show(
      BuildContext context, {
        required String title,
        required String message,
        IconData icon         = Icons.info_outline_rounded,
        Color iconColor       = AppColors.primary,
        String buttonLabel    = 'OK',
        VoidCallback? onClose,
      }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium
                    .copyWith(
                    color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            AppButton(
              label: buttonLabel,
              onPressed: () {
                Navigator.pop(context);
                onClose?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── 3. Bottom Sheet ───────────────────────
  static Future<T?> bottomSheet<T>(
      BuildContext context, {
        required String title,
        required Widget child,
        bool isDismissible = true,
      }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets
                    .symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius:
                  BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: 20),
                child: Text(title,
                    style: AppTextStyles.h2),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets
                      .symmetric(horizontal: 20),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Usage Examples ───────────────────────────
// Confirm delete:
// final ok = await AppDialog.confirm(context,
//   title: 'Delete Complaint',
//   message: 'This cannot be undone.',
//   isDanger: true);
// if (ok == true) _delete();

// Success dialog:
// AppDialog.show(context,
//   title: 'Payment Successful',
//   message: 'Invoice paid successfully.',
//   icon: Icons.check_circle_outline,
//   iconColor: AppColors.success);

// Bottom sheet:
// AppDialog.bottomSheet(context,
//   title: 'Filter Options',
//   child: FilterWidget());
