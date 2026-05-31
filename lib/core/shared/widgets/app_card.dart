// lib/shared/widgets/app_card.dart

import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';

class AppCard extends StatelessWidget {

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;
  final bool hasShadow;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius = 16,
    this.hasShadow    = true,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius:
        BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: hasShadow ? [
          BoxShadow(
            color: AppColors.primary
                .withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
        BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ??
                const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────
class AppBadge extends StatelessWidget {

  final String label;
  final Color color;
  final Color? textColor;

  const AppBadge({
    super.key,
    required this.label,
    this.color    = AppColors.primary,
    this.textColor,
  });

  // Named constructors for common statuses
  const AppBadge.success({super.key,
    required this.label}) :
        color = AppColors.success, textColor = null;

  const AppBadge.error({super.key,
    required this.label}) :
        color = AppColors.error, textColor = null;

  const AppBadge.warning({super.key,
    required this.label}) :
        color = AppColors.warning, textColor = null;

  const AppBadge.info({super.key,
    required this.label}) :
        color = AppColors.primary, textColor = null;

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor ?? color,
          ),
        ),
      );
}

// ── Usage ────────────────────────────────────
// AppBadge.success(label: 'PAID')
// AppBadge.error(label: 'OVERDUE')
// AppBadge.warning(label: 'PENDING')
// AppBadge(label: 'OPEN', color: Colors.blue)
