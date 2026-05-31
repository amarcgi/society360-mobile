import 'package:equatable/equatable.dart';

abstract class VisitorEvent extends Equatable {
  const VisitorEvent();

  @override
  List<Object?> get props => [];
}

// Triggered when Dashboard mounts
class LoadVisitors extends VisitorEvent {}

// Triggered when clicking "Save Notification" or "Pre-approve"
class AddNewVisitor extends VisitorEvent {
  final Map<String, dynamic> visitorDetails;
  const AddNewVisitor(this.visitorDetails);

  @override
  List<Object?> get props => [visitorDetails];
}

// Triggered when changing filter pills ("All", "Inside", etc.)
class ChangeFilterChip extends VisitorEvent {
  final String selectedFilter;
  const ChangeFilterChip(this.selectedFilter);

  @override
  List<Object?> get props => [selectedFilter];
}

// Triggered from Gate Approvals actions
class UpdateGateDecision extends VisitorEvent {
  final String visitorId;
  final String decision; // 'Allow', 'Deny'
  const UpdateGateDecision({required this.visitorId, required this.decision});

  @override
  List<Object?> get props => [visitorId, decision];
}