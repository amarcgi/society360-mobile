// ═══════════════════════════════════════════════
// lib/features/auth/presentation/bloc/auth_event.dart
// ═══════════════════════════════════════════════

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Fired when user taps "Send OTP"
class RequestOtpEvent extends AuthEvent {
  final String mobile;
  const RequestOtpEvent(this.mobile);
  @override
  List<Object?> get props => [mobile];
}

// Fired when user taps "Verify OTP"
class VerifyOtpEvent extends AuthEvent {
  final String mobile;
  final String otp;
  final String role;
  const VerifyOtpEvent({
    required this.mobile,
    required this.otp,
    required this.role,
  });
  @override
  List<Object?> get props => [mobile, otp, role];
}

// Fired when user taps "Resend OTP"
class ResendOtpEvent extends AuthEvent {
  final String mobile;
  const ResendOtpEvent(this.mobile);
  @override
  List<Object?> get props => [mobile];
}
