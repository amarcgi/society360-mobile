// ═══════════════════════════════════════════
// step2_flat_screen.dart
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
import '../widgets/resident_type_selector.dart';
import 'step_widgets.dart';
class Step2FlatScreen extends StatefulWidget {
  final ProfileModel data;
  final String flatNumber;
  final String buildingName;
  final String societyName;

  const Step2FlatScreen({
    super.key,
    required this.data,
    required this.flatNumber,
    required this.buildingName,
    required this.societyName,
  });

  @override
  State<Step2FlatScreen> createState() =>
      _Step2State();
}

class _Step2State extends State<Step2FlatScreen> {

  final _formKey = GlobalKey<FormState>();
  late String _residentType = widget.data.residentType;
  late final _moveInCtrl  = TextEditingController(
      text: widget.data.moveInDate ?? '');
  late final _moveOutCtrl = TextEditingController(
      text: widget.data.moveOutDate ?? '');
  late final _parkingCtrl = TextEditingController(
      text: widget.data.parkingSlot ?? '');

  @override
  void dispose() {
    _moveInCtrl.dispose();
    _moveOutCtrl.dispose();
    _parkingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        ProfileHeader(
          title: 'Flat & occupancy',
          subtitle: 'Confirm your flat details',
          step: 2, totalSteps: 4,
          showBack: true,
          onBack: () => context
              .read<ProfileBloc>()
              .add(PreviousStepEvent()),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  // Flat Info — read only
                  SectionLabel('Your flat'),
                  FlatInfoCard(
                    flatNumber:   widget.flatNumber,
                    buildingName: widget.buildingName,
                    societyName:  widget.societyName,
                  ),
                  const Gap(8),

                  // Info notice
                  InfoNotice(
                    'Your flat is pre-assigned by '
                        'society admin. Contact admin '
                        'if details are incorrect.',
                  ),
                  const Gap(20),

                  // Resident Type
                  SectionLabel('I am a'),
                  ResidentTypeSelector(
                    selected: _residentType,
                    onChanged: (val) => setState(
                            () => _residentType = val),
                  ),
                  const Gap(20),

                  // Occupancy Dates
                  SectionLabel('Occupancy dates'),
                  AppTextField(
                    label: 'Move-in date *',
                    controller: _moveInCtrl,
                    readOnly: true,
                    prefixIcon:
                    Icons.calendar_today_outlined,
                    validator: (v) =>
                    v == null || v.isEmpty
                        ? 'Move-in date required'
                        : null,
                    onTap: () => _pickDate(
                        context, _moveInCtrl,
                        firstDate: DateTime(2000)),
                  ),
                  const Gap(12),
                  AppTextField(
                    label: 'Move-out date (optional)',
                    controller: _moveOutCtrl,
                    readOnly: true,
                    prefixIcon:
                    Icons.event_busy_outlined,
                    onTap: () => _pickDate(
                        context, _moveOutCtrl,
                        firstDate: DateTime.now()),
                  ),
                  const Gap(20),

                  // Parking
                  SectionLabel('Parking slot'),
                  AppTextField(
                    label: 'Parking slot (optional)',
                    controller: _parkingCtrl,
                    prefixIcon: Icons.local_parking_outlined,
                    hint: 'e.g. B-24',
                  ),
                  const Gap(28),

                  AppButton(
                    label: 'Continue',
                    suffixIcon:
                    Icons.arrow_forward_rounded,
                    onPressed: _onContinue,
                  ),
                  /*const Gap(8),
                  AppButton.outline(
                    label: 'Back',
                    onPressed: () => context
                        .read<ProfileBloc>()
                        .add(PreviousStepEvent()),
                  ),*/
                  const Gap(16),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _pickDate(
      BuildContext context,
      TextEditingController ctrl, {
        required DateTime firstDate,
      }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text =
      '${picked.day.toString().padLeft(2,'0')}'
          ' ${_month(picked.month)} ${picked.year}';
    }
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.data.copyWith(
      residentType: _residentType,
      moveInDate:   _moveInCtrl.text,
      moveOutDate:  _moveOutCtrl.text.isEmpty
          ? null : _moveOutCtrl.text,
      parkingSlot:  _parkingCtrl.text.isEmpty
          ? null : _parkingCtrl.text,
    );
    context.read<ProfileBloc>()
        .add(NextStepEvent(updated));
  }

  String _month(int m) => [
    '','Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ][m];
}
