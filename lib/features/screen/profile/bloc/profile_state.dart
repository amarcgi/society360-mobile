// ═══════════════════════════════════════════
// Profile_state.dart
// ═══════════════════════════════════════════

import 'package:equatable/equatable.dart';
import '../models/profile_model.dart';


abstract class ProfileState extends Equatable {
  const ProfileState();
  @override List<Object?> get props => [];
}

// Which step is active (1-4)
class ProfileStepState extends ProfileState {
  final int step;
  final ProfileModel data;
  const ProfileStepState({
    required this.step,
    required this.data,
  });
  @override
  List<Object?> get props => [step, data];
}

// Submitting to backend
class ProfileLoading extends ProfileState {}

// Backend call succeeded
class ProfileSuccess extends ProfileState {}

// Backend call failed
class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);
  @override List<Object?> get props => [message];
}

