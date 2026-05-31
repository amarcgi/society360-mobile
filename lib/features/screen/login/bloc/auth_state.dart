// lib/features/auth/presentation/bloc/auth_state.dart
// ═══════════════════════════════════════════════

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// Initial — nothing happening
class AuthInitial extends AuthState {}

// OTP is being sent
class OtpRequestLoading extends AuthState {}

// OTP sent successfully — navigate to OTP screen
class OtpRequestSuccess extends AuthState {
  final String mobile;
  const OtpRequestSuccess(this.mobile);
  @override
  List<Object?> get props => [mobile];
}

// OTP send failed
class OtpRequestFailure extends AuthState {
  final String message;
  const OtpRequestFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// OTP is being verified
class OtpVerifyLoading extends AuthState {}

// OTP verified — navigate to home
class OtpVerifySuccess extends AuthState {
  final String role;
  final String? societyId;
  const OtpVerifySuccess({
    required this.role,
    this.societyId,
  });
  @override
  List<Object?> get props => [role, societyId];
}

// OTP verification failed
class OtpVerifyFailure extends AuthState {
  final String message;
  const OtpVerifyFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// OTP resent successfully
class OtpResendSuccess extends AuthState {}

