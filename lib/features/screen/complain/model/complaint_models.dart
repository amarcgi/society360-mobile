import 'complaint_enums.dart';

class RaiseComplainResponse {
  final int? complaintId;
  final int flatId;
  final int residentId;
  final int complaintCategoryId;
  final String title;
  final String description;
  final Priority priority;
  final Roles? assignedToRole;
  final int? assignedToUserId;
  final ComplaintStatus complaintStatus;
  final String? attachmentUrl;
  final DateTime? raisedAt;
  final DateTime? resolvedAt;

  const RaiseComplainResponse({
    this.complaintId,
    required this.flatId,
    required this.residentId,
    required this.complaintCategoryId,
    required this.title,
    required this.description,
    required this.priority,
    this.assignedToRole,
    this.assignedToUserId,
    required this.complaintStatus,
    this.attachmentUrl,
    this.raisedAt,
    this.resolvedAt,
  });

  factory RaiseComplainResponse.fromJson(Map<String, dynamic> json) {
    return RaiseComplainResponse(
      complaintId: json['complaintId'] as int?,
      flatId: json['flatId'] as int,
      residentId: json['residentId'] as int,
      complaintCategoryId: json['complaintCategoryId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: Priority.values.firstWhere((e) => e.name == json['priority']),
      assignedToRole: json['assignedToRole'] != null
          ? Roles.values.firstWhere((e) => e.name == json['assignedToRole'])
          : null,
      assignedToUserId: json['assignedToUserId'] as int?,
      complaintStatus: ComplaintStatus.values.firstWhere((e) => e.name == json['complaintStatus']),
      attachmentUrl: json['attachmentUrl'] as String?,
      raisedAt: json['raisedAt'] != null ? DateTime.parse(json['raisedAt']) : null,
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flatId': flatId,
      'residentId': residentId,
      'complaintCategoryId': complaintCategoryId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'assignedToRole': assignedToRole?.name,
      'assignedToUserId': assignedToUserId,
      'complaintStatus': complaintStatus.name,
      'attachmentUrl': attachmentUrl,
    };
  }
}

class ComplainCommentResponse {
  final int complaintCommentId;
  final int complaintId;
  final String comment;
  final int commentedByUserId;
  final String? attachmentUrl;
  final ComplaintStatus complaintStatus;
  final String? message;

  const ComplainCommentResponse({
    required this.complaintCommentId,
    required this.complaintId,
    required this.comment,
    required this.commentedByUserId,
    this.attachmentUrl,
    required this.complaintStatus,
    this.message,
  });

  factory ComplainCommentResponse.fromJson(Map<String, dynamic> json) {
    return ComplainCommentResponse(
      complaintCommentId: json['complaintCommentId'] as int,
      complaintId: json['complaintId'] as int,
      comment: json['comment'] as String,
      commentedByUserId: json['commentedByUserId'] as int,
      attachmentUrl: json['attachmentUrl'] as String?,
      complaintStatus: ComplaintStatus.values.firstWhere((e) => e.name == json['complaintStatus']),
      message: json['message'] as String?,
    );
  }
}