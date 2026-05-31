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
                AppCard(
                  child: Column(children: [
                    AppInfoRow(
                      label: 'Name',
                      value: data.fullName,
                    ),
                    AppInfoRow(
                      label: 'Flat',
                      value: '$buildingName — $flatNumber',
                    ),
                    AppInfoRow(
                      label: 'Type',
                      value: data.residentType,
                    ),
                    if (data.moveInDate != null)
                      AppInfoRow(
                        label: 'Move-in',
                        value: data.moveInDate!,
                      ),
                    AppInfoRow(
                      label: 'Family',
                      value: '${data.familyMembers.length}'
                          ' member(s)',
                    ),
                    AppInfoRow(
                      label: 'Vehicles',
                      value: '${data.vehicles.length}'
                          ' vehicle(s)',
                    ),
                  ]),
                ),
                const Gap(24),

                // Go to Dashboard
                AppButton(
                  label: 'Go to Dashboard',
                  suffixIcon: Icons.home_rounded,
                  onPressed: () => context
                      .read<ProfileBloc>()
                      .add(SubmitProfileEvent(data)),
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
