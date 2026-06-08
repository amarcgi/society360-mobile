import 'package:equatable/equatable.dart';
import '../model/complaint_enums.dart';
import '../model/complaint_models.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();
  @override
  List<Object?> get props => [];
}

class LoadResidentComplaints extends ComplaintEvent {
  final int residentUserId;
  const LoadResidentComplaints(this.residentUserId);
}

class SubmitNewComplaint extends ComplaintEvent {
  final RaiseComplainResponse complaint;
  const SubmitNewComplaint(this.complaint);
}

class LoadComplaintDetails extends ComplaintEvent {
  final int complaintId;
  const LoadComplaintDetails(this.complaintId);
}

class AddComplaintComment extends ComplaintEvent {
  final int complaintId;
  final String commentText;
  final int userId;
  final ComplaintStatus currentStatus;

  const AddComplaintComment({
    required this.complaintId,
    required this.commentText,
    required this.userId,
    required this.currentStatus,
  });
}