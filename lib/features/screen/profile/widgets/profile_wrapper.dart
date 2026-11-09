// ═══════════════════════════════════════════
// profile_wrapper.dart
// Controls which step screen is shown
// ═══════════════════════════════════════════
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/shared/widgets/app_bar.dart';
import '../../../../core/shared/widgets/app_loader.dart';
import '../../../../core/shared/widgets/app_snackbar.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../injection.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../models/profile_model.dart';
import 'step1_personal_screen.dart';
import 'step2_flat_screen.dart';
import 'step3_family_screen.dart';
import 'step4_success_screen.dart';

class ProfileWrapper extends StatefulWidget {
  final String mobile;
  final String societyId;
  final String buildingId;
  final String flatId;
  final String flatNumber;
  final String buildingName;
  final String societyName;

  const ProfileWrapper({
    super.key,
    required this.mobile,
    required this.societyId,
    required this.buildingId,
    required this.flatId,
    required this.flatNumber,
    required this.buildingName,
    required this.societyName,
  });

  @override
  State<ProfileWrapper> createState() =>
      _ProfileWrapperState();
}

class _ProfileWrapperState
    extends State<ProfileWrapper> {

  late final ProfileBloc _profileBloc;
  ProfileModel? profileModel;

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>()..add(LoadProfileEvent(widget.mobile));
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc,
          ProfileState>(
        bloc: _profileBloc,
        listener: (context, state) {
          if(state is ProfileLoading){
            showOverlayLoader(context,message:'Loading profile...');
          }
          if (state is ProfileLoadFailure) {
            print('object: ${state.message}');
            hideOverlayLoader();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.dashboard);
            }
            AppSnackbar.error(
                context, state.message);

          }
        },
        builder: (context, state) {
         // if (state is ProfileLoadSuccess) {
           // hideOverlayLoader();
            *//*return const Scaffold(
              body: AppFullScreenLoader(
                message: 'Saving your profile...',
              ),
            );*//*
           *//* return _buildStep(
              context,
              ProfileStepState(step: 1, data: state.resident!),
            );*//*
         // }
          print('state is ProfileStepState: ${state is ProfileStepState}');
          //hideOverlayLoader();
          if (state is ProfileStepState) {
            hideOverlayLoader();
            return _buildStep(
                context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );*/
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadFailure) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.dashboard);
            }
            AppSnackbar.error(context, state.message);
          }
          if (state is ProfileLoadSuccess) {
            if (state.resident != null) {
              context.go(AppRouter.dashboard,extra: state.resident!.toJson());
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileStepState) {
            return _buildStep(context, state);
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBars.customAppBar(
              context: context,
              title: 'Profile Setup',
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildStep(
      BuildContext context,
      ProfileStepState state) {
    return Scaffold(
        backgroundColor: AppColors.background,
       appBar: CustomAppBars.customAppBar(
         context: context,
         title: 'Profile Setup',
         showBackButton: state.step > 1,
       ),
       /* appBar: AppBar(
          backgroundColor: const Color(0xFF0D2C54),
          title: const Text('Profile Setup', style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: context.canPop()?IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ):null),*/

      body:AnimatedSwitcher(
        duration: const Duration(
            milliseconds: 300),
        transitionBuilder: (child, anim) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: anim,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
        child: switch (state.step) {
          1 => Step1PersonalScreen(
            key: const ValueKey(1),
            mobile: widget.mobile,
            data: state.data,
          ),
          2 => Step2FlatScreen(
            key: const ValueKey(2),
            data: state.data,
            flatNumber:   widget.flatNumber,
            buildingName: widget.buildingName,
            societyName:  widget.societyName,
          ),
          3 => Step3FamilyScreen(
            key: const ValueKey(3),
            data: state.data,
          ),
          4 => Step4SuccessScreen(
            key: const ValueKey(4),
            data: state.data,
            flatNumber:   widget.flatNumber,
            buildingName: widget.buildingName,
          ),
          _ => const SizedBox.shrink(),
        },
      ),

    );


  }
}
