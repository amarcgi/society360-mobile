import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/AppColors.dart';


class AppTextField extends StatefulWidget {

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? prefixText;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText  = false,
    this.readOnly     = false,
    this.maxLength,
    this.maxLines     = 1,
    this.prefixIcon,
    this.suffix,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.prefixText,
  });

  @override
  State<AppTextField> createState() =>
      _AppTextFieldState();
}

class _AppTextFieldState
    extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText
          ? _obscure : false,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      style: GoogleFonts.sora(
        fontSize: 15,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        counterText: '',
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
            color: AppColors.textSecondary,
            size: 20)
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: () => setState(
                  () => _obscure = !_obscure),
        )
            : widget.suffix,
      ),
    );
  }
}

// ── Usage ────────────────────────────────────
// AppTextField(label: 'Mobile', controller: _ctrl)
// AppTextField(label: 'Password', obscureText: true)
// AppTextField(label: 'Amount', prefixText: '₹ ',
//   keyboardType: TextInputType.number)
// AppTextField(label: 'Description', maxLines: 4)

