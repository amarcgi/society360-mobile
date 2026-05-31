// ═══════════════════════════════════════════
// widgets/resident_type_selector.dart
// ═══════════════════════════════════════════

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/AppColors.dart';

class ResidentTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const ResidentTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final _types = const [
    ('OWNER',  'Owner',  Icons.home_rounded),
    ('TENANT', 'Tenant', Icons.key_rounded),
    ('FAMILY', 'Family', Icons.people_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _types.map((t) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(
              right: t == _types.last ? 0 : 8),
          child: GestureDetector(
            onTap: () => onChanged(t.$1),
            child: AnimatedContainer(
              duration:
              const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  vertical: 14),
              decoration: BoxDecoration(
                color: selected == t.$1
                    ? AppColors.primary
                    .withOpacity(0.08)
                    : AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(12),
                border: Border.all(
                  color: selected == t.$1
                      ? AppColors.primary
                      : AppColors.border,
                  width: selected == t.$1
                      ? 1.5 : 1,
                ),
              ),
              child: Column(children: [
                Icon(t.$3,
                  size: 22,
                  color: selected == t.$1
                      ? AppColors.primary
                      : AppColors.textHint,
                ),
                const SizedBox(height: 6),
                Text(t.$2,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected == t.$1
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selected == t.$1
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    )),
              ]),
            ),
          ),
        ),
      )).toList(),
    );
  }
}

