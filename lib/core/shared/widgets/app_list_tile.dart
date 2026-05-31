// lib/shared/widgets/app_list_tile.dart

import 'package:flutter/material.dart';


import '../../theme/AppColors.dart';
import 'app_text_styles.dart';

class AppListTile extends StatelessWidget {

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) =>
      Column(
        children: [
          ListTile(
            title: Text(title,
                style: AppTextStyles.bodyMedium
                    .copyWith(
                    fontWeight: FontWeight.w500)),
            subtitle: subtitle != null
                ? Text(subtitle!,
                style: AppTextStyles.caption)
                : null,
            leading: leading,
            trailing: trailing ?? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
            ),
            onTap: onTap,
            contentPadding:
            const EdgeInsets.symmetric(
                horizontal: 0, vertical: 4),
          ),
          if (showDivider)
            const Divider(
              height: 1,
              color: AppColors.border,
            ),
        ],
      );
}

// ── Info Row ─────────────────────────────────
// Key-value pair row for detail screens
class AppInfoRow extends StatelessWidget {

  final String label;
  final String value;
  final Color? valueColor;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppTextStyles.bodySmall),
            Text(value,
                style: AppTextStyles.labelLarge
                    .copyWith(color: valueColor)),
          ],
        ),
      );
}

// ── Usage ─────────────────────────────────────
// AppInfoRow(label: 'Invoice No', value: 'INV-001')
// AppInfoRow(label: 'Status', value: 'PAID',
//   valueColor: AppColors.success)
// AppInfoRow(label: 'Amount', value: '₹2,500',
//   valueColor: AppColors.primary)
