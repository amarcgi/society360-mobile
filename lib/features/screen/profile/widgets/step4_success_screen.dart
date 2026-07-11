// ═══════════════════════════════════════════
// step4_success_screen.dart
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_card.dart';
import '../../../../core/shared/widgets/app_list_tile.dart';
import '../../../../core/shared/widgets/app_spacing.dart';
import '../../../../core/shared/widgets/app_text_styles.dart';
import '../../../../core/theme/AppColors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../models/profile_model.dart';
import '../widgets/profile_header.dart';

class Step4SuccessScreen extends StatelessWidget {
  final ProfileModel data;
  final String flatNumber;
  final String buildingName;

  const Step4SuccessScreen({
    super.key,
    required this.data,
    required this.flatNumber,
    required this.buildingName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        ProfileHeader(
          title: 'Profile complete',
          subtitle: 'You are all set!',
          step: 4, totalSteps: 4,
          showBack: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                // Success icon
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.success
                        .withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 48,
                    color: AppColors.success,
                  ),
                ),
                const Gap(20),

                Text('Welcome to Society360!',
                  style: GoogleFonts.sora(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  'Your profile has been created.'
                      ' Here is a summary.',
                  style: GoogleFonts.sora(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),

                // Summary Card
                // Summary Card
                AppCard(
                  child: Column(children: [
                    AppInfoRow(label: 'Name', value: data.fullName),
                    AppInfoRow(label: 'Flat', value: '$buildingName — $flatNumber'),
                    AppInfoRow(label: 'Type', value: data.residentType),
                    if (data.moveInDate != null)
                      AppInfoRow(label: 'Move-in', value: data.moveInDate!),
                    // Family Expansion Tile
                    // Family Members Row
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
                      ),
                      child: ExpansionTile(
                        // 1. Match the vertical padding used in AppInfoRow (vertical: 8)
                        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        // 2. Reduce the density so it doesn't add extra vertical/horizontal spacing
                        visualDensity: VisualDensity.compact,
                        childrenPadding: EdgeInsets.zero,

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Family members", style: AppTextStyles.bodyLarge),
                            Text(
                              "${data.familyMembers.length} member(s) added",
                              style: AppTextStyles.labelLarge,
                            ),
                          ],
                        ),

                        children: data.familyMembers.map((m) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0), // Align content
                          child: ListTile(
                            dense: true,
                            // Match the AppInfoRow alignment
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            leading: const Icon(Icons.people, size: 20),
                            title: Text(m.name),
                            subtitle: Text(m.mobile),
                            trailing: Text(m.relation),
                          ),
                        )).toList(),
                      ),
                    ),
                    // Vehicles Expansion Tile
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
                      ),
                      child: ExpansionTile(
                        // 1. Match the vertical padding used in AppInfoRow (vertical: 8)
                        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        // 2. Reduce the density so it doesn't add extra vertical/horizontal spacing
                        visualDensity: VisualDensity.compact,
                        childrenPadding: EdgeInsets.zero,

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Vehicles", style: AppTextStyles.bodyLarge),
                            Text(
                              "${data.vehicles.length} vehicle(s) added",
                              style: AppTextStyles.labelLarge,
                            ),
                          ],
                        ),

                        children: data.vehicles.map((m) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              m.vehicleType == 'TWO_WHEELER' ? Icons.two_wheeler : Icons.directions_car_outlined,
                              size: 20,
                            ),
                            contentPadding: EdgeInsets.zero,
                            title: Text(m.vehicleNumber),
                            trailing: Text(m.vehicleType),
                          ),
                        )).toList(),
                      ),
                    ),
                  ]),
                ),
                const Gap(24),

                // Go to Dashboard
                AppButton(
                  label: 'Save',
                  suffixIcon: Icons.save,
                  onPressed: () {
                    /*print('=== Profile Data ===');
                    print('Full Name: ${data.fullName}');
                    print('Building: $buildingName');
                    print('Flat Number: $flatNumber');
                    print('Resident Type: ${data.residentType}');
                    print('Move-in Date: ${data.moveInDate}');
                    print('Family Members: ${data.familyMembers.length}');
                    for (var member in data.familyMembers) {
                      print('  - ${member.name} (${member.relation}): ${member.mobile}');
                    }
                    print('Vehicles: ${data.vehicles.length}');
                    for (var vehicle in data.vehicles) {
                      print('  - ${vehicle.vehicleNumber} (${vehicle.vehicleType})');
                    }
                    print('==================');*/
                    //context.read<ProfileBloc>().add(SubmitProfileEvent(data));
                  },
                ),
                const Gap(8),
                AppButton.outline(
                  label: 'Edit profile',
                  onPressed: () => context
                      .read<ProfileBloc>()
                      .add(PreviousStepEvent()),
                ),
                const Gap(16),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
