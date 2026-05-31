// ═══════════════════════════════════════════
// step1_personal_screen.dart
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_spacing.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/AppColors.dart';


import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../models/profile_model.dart';
import '../widgets/profile_header.dart';
import 'step_widgets.dart';
class Step1PersonalScreen extends StatefulWidget {
  final String mobile;
  final ProfileModel data;

  const Step1PersonalScreen({
    super.key,
    required this.mobile,
    required this.data,
  });

  @override
  State<Step1PersonalScreen> createState() =>
      _Step1State();
}

class _Step1State
    extends State<Step1PersonalScreen> {

  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(
      text: widget.data.fullName);
  late final _emailCtrl = TextEditingController(
      text: widget.data.email ?? '');
  late final _dobCtrl = TextEditingController(
      text: widget.data.dateOfBirth ?? '');
  late final _ecNameCtrl = TextEditingController(
      text: widget.data.emergencyContactName ?? '');
  late final _ecMobCtrl = TextEditingController(
      text: widget.data.emergencyContactMobile ?? '');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    _ecNameCtrl.dispose();
    _ecMobCtrl.dispose();
    super.dispose();
  }

  String get _initials {
    final n = _nameCtrl.text.trim();
    if (n.isEmpty) return '?';
    final p = n.split(' ');
    if (p.length == 1) return p[0][0].toUpperCase();
    return (p[0][0] + p[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [

        // ── Header ────────────────────────
        ProfileHeader(
          title: 'Personal information',
          subtitle: 'Tell us about yourself',
          step: 1,
          totalSteps: 4,
          showBack: false,
        ),

        // ── Body ──────────────────────────
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets
                  .all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  // Avatar
                  Center(
                    child: Column(children: [
                      Stack(children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _initials,
                              style: GoogleFonts.sora(
                                fontSize: 28,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 26, height: 26,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.background,
                                  width: 2),
                            ),
                            child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 13),
                          ),
                        ),
                      ]),
                      const Gap(8),
                      Text('Add profile photo',
                          style: GoogleFonts.sora(
                              fontSize: 12,
                              color: AppColors.textSecondary
                          )),
                    ]),
                  ),

                  const Gap(24),

                  // Basic Details
                  SectionLabel('Basic details'),
                  AppTextField(
                    label: 'Full name *',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) =>
                    v == null
                        || v
                        .trim()
                        .isEmpty
                        ? 'Full name is required'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Gap(12),

                  // Mobile — read only
                  ReadOnlyField(
                    label: 'Mobile number',
                    value: '+91 ${widget.mobile}',
                    icon: Icons.phone_outlined,
                    trailing: VerifiedBadge(),
                  ),
                  const Gap(12),

                  AppTextField(
                    label: 'Email address (optional)',
                    controller: _emailCtrl,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType:
                    TextInputType.emailAddress,
                  ),
                  const Gap(20),

                  // Date of Birth
                  SectionLabel('Date of birth'),
                  AppTextField(
                    label: 'Date of birth (optional)',
                    controller: _dobCtrl,
                    readOnly: true,
                    prefixIcon: Icons.cake_outlined,
                    onTap: () =>
                        _pickDate(
                            context, _dobCtrl),
                  ),
                  const Gap(20),

                  // Emergency Contact
                  SectionLabel('Emergency contact'),
                  AppTextField(
                    label: 'Contact name',
                    controller: _ecNameCtrl,
                    prefixIcon: Icons.person_pin_outlined,
                  ),
                  const Gap(12),
                  AppTextField(
                    label: 'Contact mobile',
                    controller: _ecMobCtrl,
                    prefixIcon: Icons.phone_in_talk_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                  const Gap(28),

                  // Continue Button
                  AppButton(
                    label: 'Continue',
                    suffixIcon: Icons.arrow_forward_rounded,
                    onPressed: _onContinue,
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _pickDate(BuildContext context,
      TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ctrl.text =
      '${picked.day.toString().padLeft(2, '0')}'
          ' ${_monthName(picked.month)}'
          ' ${picked.year}';
    }
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.data.copyWith(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text
          .trim()
          .isEmpty
          ? null : _emailCtrl.text.trim(),
      dateOfBirth: _dobCtrl.text.isEmpty
          ? null : _dobCtrl.text,
      emergencyContactName:
      _ecNameCtrl.text
          .trim()
          .isEmpty
          ? null : _ecNameCtrl.text.trim(),
      emergencyContactMobile:
      _ecMobCtrl.text
          .trim()
          .isEmpty
          ? null : _ecMobCtrl.text.trim(),
    );

    context.read<ProfileBloc>()
        .add(NextStepEvent(updated));
  }

  String _monthName(int m) =>
      [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
