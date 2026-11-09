// ═══════════════════════════════════════════
// Profile_bloc.dart
// ═══════════════════════════════════════════

import 'dart:async';

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
    on<LoadProfileEvent>(_onLoadProfile);
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

   /* emit(ProfileLoading());

    try {
      await _repository.saveProfile(event.data);
      // Mark Profile complete in storage
      await SecureStorage.saveProfileDone('true');
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileFailure(
          e.toString()
              .replaceAll('Exception: ', '')));
    }*/

    try {
      //await _repository.saveProfile(event.data);
      // Mark Profile complete in storage
      await SecureStorage.saveProfileDone('true');
      emit(ProfileLoadSuccess(resident: event.data));
    } catch (e) {
      emit(ProfileLoadFailure(
          e.toString()
              .replaceAll('Exception: ', '')));
    }

  }

  FutureOr<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      // 1. Await the asynchronous operation
      final data = await _repository.getMyProfileByMobileNo(event.mobile);
      print('data: $data');
      // 2. Check if the handler is still active before emitting (prevents state leaks)
     // if (emit.isDone) return;

      /*if (data != null) {
        emit(ProfileLoadSuccess(resident: data));

      } else {
        emit(ProfileLoadFailure('Profile not found'));
      }*/
      if (data != null) {
        emit(ProfileStepState(step: 1, data: data));
      } else {
        emit(ProfileLoadFailure('Profile not found'));
      }


    } catch (error) {
      //if (emit.isDone) return;
      print('Error: $error');
      emit(ProfileLoadFailure(error.toString()));
    }
  }



}
