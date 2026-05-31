// lib/shared/widgets/app_empty_state.dart

import 'package:flutter/material.dart';

import '../../theme/AppColors.dart';
import 'app_button.dart';
import 'app_text_styles.dart';

class AppEmptyState extends StatelessWidget {

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    size: 44,
                    color: AppColors.primary
                        .withOpacity(0.5)),
              ),
              const SizedBox(height: 24),
              Text(title,
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!,
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center),
              ],
              if (buttonLabel != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  label: buttonLabel!,
                  fullWidth: false,
                  onPressed: onButtonPressed,
                ),
              ],
            ],
          ),
        ),
      );
}

// ── Usage Examples ───────────────────────────
// No complaints:
// AppEmptyState(
//   icon: Icons.inbox_outlined,
//   title: 'No Complaints',
//   subtitle: 'All issues resolved!',
// )

// No invoices with action:
// AppEmptyState(
//   icon: Icons.receipt_long_outlined,
//   title: 'No Invoices',
//   subtitle: 'No pending payments.',
//   buttonLabel: 'Refresh',
//   onButtonPressed: _refresh,
// )
