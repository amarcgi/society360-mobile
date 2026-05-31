// Profile_event.dart
// ═══════════════════════════════════════════

import 'package:equatable/equatable.dart';
import '../models/profile_model.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override List<Object?> get props => [];
}

// Move to next step with updated data
class NextStepEvent extends ProfileEvent {
  final ProfileModel data;
  const NextStepEvent(this.data);
  @override List<Object?> get props => [data];
}

// Go back to previous step
class PreviousStepEvent extends ProfileEvent {}

// Final submit — calls backend
class SubmitProfileEvent extends ProfileEvent {
  final ProfileModel data;
  const SubmitProfileEvent(this.data);
  @override List<Object?> get props => [data];
}

