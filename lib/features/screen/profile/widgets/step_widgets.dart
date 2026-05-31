// ═══════════════════════════════════════════
// Shared private widgets used across steps
// Put at bottom of each step file OR in
// a shared step_widgets.dart file
// ═══════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_card.dart';
import '../../../../core/theme/AppColors.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.only(
            bottom: 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      );
}

class ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Widget? trailing;

  const ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.border),
        ),
        child: Row(children: [
          Icon(icon,
              size: 20,
              color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
            ],
          )),
          if (trailing != null) trailing!,
        ]),
      );
}

class VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Verified',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: AppColors.success)),
      );
}

class FlatInfoCard extends StatelessWidget {
  final String flatNumber;
  final String buildingName;
  final String societyName;

  const FlatInfoCard({
    required this.flatNumber,
    required this.buildingName,
    required this.societyName,
  });

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.apartment_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text('$buildingName — Flat $flatNumber',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF085041))),
              Text(societyName,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.success)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Assigned',
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ]),
      );
}

class InfoNotice extends StatelessWidget {
  final String text;
  const InfoNotice(this.text);

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 16, color: AppColors.warning),
            const SizedBox(width: 8),
            Expanded(child: Text(text,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF633806),
                    height: 1.4))),
          ],
        ),
      );
}

class ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) =>
      AppCard(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        child: Row(children: [
          Expanded(child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
            ],
          )),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ]),
      );
}

class AddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const AddButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18,
                  color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
}
