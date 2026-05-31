// ═══════════════════════════════════════════
// step3_family_screen.dart
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/profile/widgets/type_chip.dart';


import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_dialog.dart';
import '../../../../core/shared/widgets/app_spacing.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/AppColors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

import '../models/family_member_model.dart';
import '../models/profile_model.dart';
import '../models/vehicle_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/family_member_tile.dart';
import '../widgets/vehicle_tile.dart';

import 'step_widgets.dart';

class Step3FamilyScreen extends StatefulWidget {
  final ProfileModel data;
  const Step3FamilyScreen({
    super.key, required this.data});

  @override
  State<Step3FamilyScreen> createState() =>
      _Step3State();
}

class _Step3State
    extends State<Step3FamilyScreen> {

  late List<FamilyMemberModel> _members;
  late List<VehicleModel> _vehicles;
  late bool _visitorNotif;
  late bool _packageNotif;
  late bool _announcementAlert;

  @override
  void initState() {
    super.initState();
    _members   = List.from(widget.data.familyMembers);
    _vehicles  = List.from(widget.data.vehicles);
    _visitorNotif     = widget.data.visitorNotifications;
    _packageNotif     = widget.data.packageNotifications;
    _announcementAlert= widget.data.announcementAlerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        ProfileHeader(
          title: 'Family & vehicles',
          subtitle: 'Add others living with you',
          step: 3, totalSteps: 4,
          showBack: true,
          onBack: () => context
              .read<ProfileBloc>()
              .add(PreviousStepEvent()),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                // Family Members
                SectionLabel('Family members'),
                ..._members.map((m) =>
                    FamilyMemberTile(
                      member: m,
                      onDelete: () => setState(
                              () => _members.remove(m)),
                    ),
                ),
                AddButton(
                  label: 'Add family member',
                  icon: Icons.person_add_outlined,
                  onTap: () =>
                      _showAddMemberSheet(context),
                ),
                const Gap(20),

                // Vehicles
                SectionLabel('Vehicles'),
                ..._vehicles.map((v) =>
                    VehicleTile(
                      vehicle: v,
                      onDelete: () => setState(
                              () => _vehicles.remove(v)),
                    ),
                ),
                AddButton(
                  label: 'Add vehicle',
                  icon: Icons.directions_car_outlined,
                  onTap: () =>
                      _showAddVehicleSheet(context),
                ),
                const Gap(20),

                // Preferences
                SectionLabel('Notifications'),
                ToggleRow(
                  title: 'Visitor notifications',
                  subtitle: 'Alert when visitor arrives',
                  value: _visitorNotif,
                  onChanged: (v) => setState(
                          () => _visitorNotif = v),
                ),
                const Gap(8),
                ToggleRow(
                  title: 'Package notifications',
                  subtitle: 'Alert when parcel arrives',
                  value: _packageNotif,
                  onChanged: (v) => setState(
                          () => _packageNotif = v),
                ),
                const Gap(8),
                ToggleRow(
                  title: 'Announcement alerts',
                  subtitle: 'Society news & updates',
                  value: _announcementAlert,
                  onChanged: (v) => setState(
                          () => _announcementAlert = v),
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
                ),
                const Gap(16),*/
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _onContinue() {
    final updated = widget.data.copyWith(
      familyMembers: _members,
      vehicles: _vehicles,
      visitorNotifications:  _visitorNotif,
      packageNotifications:  _packageNotif,
      announcementAlerts:    _announcementAlert,
    );
    context.read<ProfileBloc>()
        .add(NextStepEvent(updated));
  }

  Future<void> _showAddMemberSheet(
      BuildContext context) async {
    final nameCtrl     = TextEditingController();
    final mobileCtrl   = TextEditingController();
    String relation    = 'SPOUSE';
    final relations    = [
      'SPOUSE','CHILD','PARENT','SIBLING','OTHER'];

    await AppDialog.bottomSheet(context,
      title: 'Add Family Member',
      child: StatefulBuilder(
        builder: (ctx, setS) => Column(children: [
          AppTextField(
            label: 'Full name *',
            controller: nameCtrl,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const Gap(12),
          AppTextField(
            label: 'Mobile number *',
            controller: mobileCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            prefixIcon: Icons.phone_outlined,
          ),
          const Gap(12),
          DropdownButtonFormField<String>(
            value: relation,
            decoration: const InputDecoration(
                labelText: 'Relation'),
            items: relations.map((r) =>
                DropdownMenuItem(
                    value: r, child: Text(r))).toList(),
            onChanged: (v) =>
                setS(() => relation = v!),
          ),
          const Gap(20),
          AppButton(
            label: 'Add Member',
            onPressed: () {
              if (nameCtrl.text.isNotEmpty
                  && mobileCtrl.text.length == 10) {
                setState(() => _members.add(
                    FamilyMemberModel(
                      name:     nameCtrl.text.trim(),
                      mobile:   mobileCtrl.text.trim(),
                      relation: relation,
                    )));
                Navigator.pop(context);
              }
            },
          ),
          const Gap(16),
        ]),
      ),
    );
  }

  Future<void> _showAddVehicleSheet(
      BuildContext context) async {
    final plateCtrl = TextEditingController();
    final makeCtrl  = TextEditingController();
    final colorCtrl = TextEditingController();
    String type     = 'FOUR_WHEELER';

    await AppDialog.bottomSheet(context,
      title: 'Add Vehicle',
      child: StatefulBuilder(
        builder: (ctx, setS) => Column(children: [
          Row(children: [
            Expanded(child: TypeChip(
              label: '4 Wheeler',
              icon: Icons.directions_car_rounded,
              selected: type == 'FOUR_WHEELER',
              onTap: () =>
                  setS(() => type = 'FOUR_WHEELER'),
            )),
            const Gap.h(8),
            Expanded(child: TypeChip(
              label: '2 Wheeler',
              icon: Icons.two_wheeler_rounded,
              selected: type == 'TWO_WHEELER',
              onTap: () =>
                  setS(() => type = 'TWO_WHEELER'),
            )),
          ]),
          const Gap(12),
          AppTextField(
            label: 'Vehicle number *',
            controller: plateCtrl,
            hint: 'MH 12 AB 1234',
            prefixIcon: Icons.pin_outlined,
          ),
          const Gap(12),
          AppTextField(
            label: 'Make / Model (optional)',
            controller: makeCtrl,
            hint: 'e.g. Maruti Swift',
            prefixIcon: Icons.directions_car_outlined,
          ),
          const Gap(12),
          AppTextField(
            label: 'Color (optional)',
            controller: colorCtrl,
            prefixIcon: Icons.color_lens_outlined,
          ),
          const Gap(20),
          AppButton(
            label: 'Add Vehicle',
            onPressed: () {
              if (plateCtrl.text.isNotEmpty) {
                setState(() => _vehicles.add(
                    VehicleModel(
                      vehicleNumber: plateCtrl.text
                          .trim().toUpperCase(),
                      vehicleType:   type,
                      make:  makeCtrl.text.trim().isEmpty
                          ? null : makeCtrl.text.trim(),
                      color: colorCtrl.text.trim().isEmpty
                          ? null : colorCtrl.text.trim(),
                    )));
                Navigator.pop(context);
              }
            },
          ),
          const Gap(16),
        ]),
      ),
    );
  }
}
