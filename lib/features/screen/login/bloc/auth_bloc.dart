
// ═══════════════════════════════════════════════
// lib/features/auth/presentation/bloc/auth_bloc.dart
// ═══════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {

    // ── Handle RequestOtpEvent ────────────
    on<RequestOtpEvent>(_onRequestOtp);

    // ── Handle VerifyOtpEvent ─────────────
    on<VerifyOtpEvent>(_onVerifyOtp);

    // ── Handle ResendOtpEvent ─────────────
    on<ResendOtpEvent>(_onResendOtp);
  }

  Future<void> _onRequestOtp(
      RequestOtpEvent event,
      Emitter<AuthState> emit) async {

    emit(OtpRequestLoading());

    try {
      //TODO as if no api is there, just simulating success response
      //await _repository.requestOtp(event.mobile);
      emit(OtpRequestSuccess(event.mobile));
    } catch (e) {
      emit(OtpRequestFailure(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event,
      Emitter<AuthState> emit) async {

    emit(OtpVerifyLoading());

    try {
     // final response = await _repository.verifyOtp(
     //   event.mobile,
     //   event.otp,
     //   event.role,
     // );

      //emit(OtpVerifySuccess(
      //  role: response.role,
      //  societyId: response.societyId,
      //));

      emit(OtpVerifySuccess(
        role: 'response.role',
        societyId: 'response.societyId',
      ));
    } catch (e) {
      emit(OtpVerifyFailure(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResendOtp(
      ResendOtpEvent event,
      Emitter<AuthState> emit) async {
    try {
      await _repository.requestOtp(event.mobile);
      emit(OtpResendSuccess());
    } catch (e) {
      emit(OtpRequestFailure(
          e.toString().replaceAll('Exception: ', '')));
    }
  }
}