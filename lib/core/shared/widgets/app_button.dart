// lib/shared/widgets/app_button.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/AppColors.dart';

enum AppButtonVariant { primary, secondary,
  outline, ghost, danger }
enum AppButtonSize    { small, medium, large }

class AppButton extends StatelessWidget {

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size    = AppButtonSize.medium,
    this.isLoading  = false,
    this.fullWidth  = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  // ── Named constructors for convenience ────
  const AppButton.secondary({
    super.key, required this.label,
    this.onPressed, this.isLoading = false,
    this.fullWidth = true,
    this.prefixIcon, this.suffixIcon,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key, required this.label,
    this.onPressed, this.isLoading = false,
    this.fullWidth = true,
    this.prefixIcon, this.suffixIcon,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.outline;

  const AppButton.danger({
    super.key, required this.label,
    this.onPressed, this.isLoading = false,
    this.fullWidth = true,
    this.prefixIcon, this.suffixIcon,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final h = switch (size) {
      AppButtonSize.small  => 40.0,
      AppButtonSize.medium => 52.0,
      AppButtonSize.large  => 60.0,
    };
    final fs = switch (size) {
      AppButtonSize.small  => 13.0,
      AppButtonSize.medium => 15.0,
      AppButtonSize.large  => 17.0,
    };

    final bg = switch (variant) {
      AppButtonVariant.primary   => AppColors.primary,
      AppButtonVariant.secondary => AppColors.accent,
      AppButtonVariant.outline   => Colors.transparent,
      AppButtonVariant.ghost     => Colors.transparent,
      AppButtonVariant.danger    => AppColors.error,
    };

    final fg = switch (variant) {
      AppButtonVariant.outline => AppColors.primary,
      AppButtonVariant.ghost   => AppColors.primary,
      _                        => Colors.white,
    };

    final border = variant == AppButtonVariant.outline
        ? Border.all(color: AppColors.primary, width: 1.5)
        : null;

    Widget child = isLoading
        ? SizedBox(
      width: 22, height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: fg,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: fs + 2,
              color: fg),
          const SizedBox(width: 8),
        ],
        Text(label,
            style: GoogleFonts.sora(
              fontSize: fs,
              fontWeight: FontWeight.w600,
              color: fg,
            )),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(suffixIcon, size: fs + 2,
              color: fg),
        ],
      ],
    );

    Widget button = Container(
      height: h,
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: onPressed == null
            ? Colors.grey.shade300 : bg,
        borderRadius: BorderRadius.circular(14),
        border: border,
        gradient: variant == AppButtonVariant.primary
            && onPressed != null
            ? AppColors.primaryGradient : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(child: child),
        ),
      ),
    );

    return fullWidth ? button
        : IntrinsicWidth(child: button);
  }
}

// ── Usage Examples ───────────────────────────
// AppButton(label: 'Send OTP', onPressed: _send)
// AppButton(label: 'Loading...', isLoading: true)
// AppButton.outline(label: 'Cancel', onPressed: _cancel)
// AppButton.danger(label: 'Delete', onPressed: _delete)
// AppButton(label: 'Pay', prefixIcon: Icons.payment)
