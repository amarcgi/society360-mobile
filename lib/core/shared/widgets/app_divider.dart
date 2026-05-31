import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/AppColors.dart';
import 'app_text_styles.dart';

// ── Section Header ────────────────────────────
class AppSectionHeader extends StatelessWidget {

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) =>
      Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h3),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!,
                  style: GoogleFonts.sora(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  )),
            ),
        ],
      );
}

// ── Search Bar ────────────────────────────────
class AppSearchBar extends StatelessWidget {

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hint       = 'Search...',
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) =>
      TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      );
}

// ── App Bar ───────────────────────────────────
PreferredSizeWidget appBar(
    String title, {
      List<Widget>? actions,
      bool showBack = true,
      PreferredSizeWidget? bottom,
    }) {
  return AppBar(
    title: Text(title,
        style: AppTextStyles.h3),
    centerTitle: false,
    automaticallyImplyLeading: showBack,
    backgroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    actions: actions,
    bottom: bottom,
  );
}

// ── Usage ─────────────────────────────────────
// AppSectionHeader(title: 'Recent Complaints',
//   actionLabel: 'View All', onAction: _viewAll)
// AppSearchBar(onChanged: _filter)
// appBar('My Invoices', actions: [IconButton(...)])
