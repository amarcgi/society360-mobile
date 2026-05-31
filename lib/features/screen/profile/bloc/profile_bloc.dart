// ═══════════════════════════════════════════
// Profile_bloc.dart
// ═══════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/profile/bloc/profile_event.dart';
import 'package:society360_app/features/screen/profile/bloc/profile_state.dart';

import '../../../data/repositories/profile_repository.dart';


import '../../../../../core/storage/secure_storage.dart';
import '../models/profile_model.dart';

class ProfileBloc
    extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository _repository;

  ProfileBloc(this._repository)
      : super(ProfileStepState(
    step: 1,
    data: ProfileModel(
      fullName: '',
      mobile: '',
    ),
  )) {
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<SubmitProfileEvent>(_onSubmit);
  }

  void _onNextStep(
      NextStepEvent event,
      Emitter<ProfileState> emit) {

    final current = state as ProfileStepState;

    if (current.step < 4) {
      emit(ProfileStepState(
        step: current.step + 1,
        data: event.data,
      ));
    }
  }

  void _onPreviousStep(
      PreviousStepEvent event,
      Emitter<ProfileState> emit) {

    final current = state as ProfileStepState;

    if (current.step > 1) {
      emit(ProfileStepState(
        step: current.step - 1,
        data: current.data,
      ));
    }
  }

  Future<void> _onSubmit(
      SubmitProfileEvent event,
      Emitter<ProfileState> emit) async {

    emit(ProfileLoading());

    try {
      await _repository.saveProfile(event.data);
      // Mark Profile complete in storage
      await SecureStorage.saveProfileDone('true');
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileFailure(
          e.toString()
              .replaceAll('Exception: ', '')));
    }
  }
}
