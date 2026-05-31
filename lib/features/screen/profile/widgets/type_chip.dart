// lib/features/Profile/presentation/widgets/
//              type_chip.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/AppColors.dart';

class TypeChip extends StatelessWidget {

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const TypeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? AppColors.primary
                  : AppColors.textHint,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Usage in Step 3 (vehicle type picker) ─────
// Row(children: [
//   Expanded(
//     child: TypeChip(
//       label: '4 Wheeler',
//       icon: Icons.directions_car_rounded,
//       selected: type == 'FOUR_WHEELER',
//       onTap: () => setState(
//           () => type = 'FOUR_WHEELER'),
//     ),
//   ),
//   const Gap.h(8),
//   Expanded(
//     child: TypeChip(
//       label: '2 Wheeler',
//       icon: Icons.two_wheeler_rounded,
//       selected: type == 'TWO_WHEELER',
//       onTap: () => setState(
//           () => type = 'TWO_WHEELER'),
//     ),
//   ),
// ])