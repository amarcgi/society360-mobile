import 'package:equatable/equatable.dart';

import '../model/complaint_models.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();
  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}
class ComplaintLoading extends ComplaintState {}

class ResidentComplaintsLoaded extends ComplaintState {
  final List<RaiseComplainResponse> complaints;
  const ResidentComplaintsLoaded(this.complaints);
  @override
  List<Object?> get props => [complaints];
}

class ComplaintDetailsLoaded extends ComplaintState {
  final RaiseComplainResponse complaint;
  final List<ComplainCommentResponse> comments;
  const ComplaintDetailsLoaded(this.complaint, this.comments);
  @override
  List<Object?> get props => [complaint, comments];
}

class ComplaintFailure extends ComplaintState {
  final String message;
  const ComplaintFailure(this.message);
}