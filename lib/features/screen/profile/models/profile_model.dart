import 'package:equatable/equatable.dart';
import 'package:society360_app/features/screen/profile/models/vehicle_model.dart';

import 'family_member_model.dart';

class ProfileModel extends Equatable {
  // Personal
  final String fullName;
  final String mobile;
  final String? email;
  final String? dateOfBirth;
  final String? emergencyContactName;
  final String? emergencyContactMobile;
  final String? photoUrl;

  // Resident metadata
  final bool? active;
  final int? buildingId;
  final String? createdAt;
  final int? createdBy;
  final int? flatId;
  final String? flatNo;
  final String? residentEmail;
  final String? residentFirstName;
  final int? residentId;
  final String? residentLastName;
  final String? residentMobile;
  final String? residentRole;
  final String? societyId;
  final String? updatedAt;
  final int? updatedBy;

  // Flat
  final String residentType;
  final String? moveInDate;
  final String? moveOutDate;
  final String? parkingSlot;

  // Family and vehicles
  final List<FamilyMemberModel> familyMembers;
  final List<VehicleModel> vehicles;

  // Notification preferences
  final bool visitorNotifications;
  final bool packageNotifications;
  final bool announcementAlerts;

  const ProfileModel({
    required this.fullName,
    required this.mobile,
    this.email,
    this.dateOfBirth,
    this.emergencyContactName,
    this.emergencyContactMobile,
    this.photoUrl,
    this.active,
    this.buildingId,
    this.createdAt,
    this.createdBy,
    this.flatId,
    this.flatNo,
    this.residentEmail,
    this.residentFirstName,
    this.residentId,
    this.residentLastName,
    this.residentMobile,
    this.residentRole,
    this.societyId,
    this.updatedAt,
    this.updatedBy,
    this.residentType = 'OWNER',
    this.moveInDate,
    this.moveOutDate,
    this.parkingSlot,
    this.familyMembers = const [],
    this.vehicles = const [],
    this.visitorNotifications = true,
    this.packageNotifications = true,
    this.announcementAlerts = true,
  });

  ProfileModel copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? dateOfBirth,
    String? emergencyContactName,
    String? emergencyContactMobile,
    String? photoUrl,
    bool? active,
    int? buildingId,
    String? createdAt,
    int? createdBy,
    int? flatId,
    String? flatNo,
    String? residentEmail,
    String? residentFirstName,
    int? residentId,
    String? residentLastName,
    String? residentMobile,
    String? residentRole,
    String? societyId,
    String? updatedAt,
    int? updatedBy,
    String? residentType,
    String? moveInDate,
    String? moveOutDate,
    String? parkingSlot,
    List<FamilyMemberModel>? familyMembers,
    List<VehicleModel>? vehicles,
    bool? visitorNotifications,
    bool? packageNotifications,
    bool? announcementAlerts,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContactName:
      emergencyContactName ?? this.emergencyContactName,
      emergencyContactMobile:
      emergencyContactMobile ?? this.emergencyContactMobile,
      photoUrl: photoUrl ?? this.photoUrl,
      active: active ?? this.active,
      buildingId: buildingId ?? this.buildingId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      flatId: flatId ?? this.flatId,
      flatNo: flatNo ?? this.flatNo,
      residentEmail: residentEmail ?? this.residentEmail,
      residentFirstName: residentFirstName ?? this.residentFirstName,
      residentId: residentId ?? this.residentId,
      residentLastName: residentLastName ?? this.residentLastName,
      residentMobile: residentMobile ?? this.residentMobile,
      residentRole: residentRole ?? this.residentRole,
      societyId: societyId ?? this.societyId,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      residentType: residentType ?? this.residentType,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      parkingSlot: parkingSlot ?? this.parkingSlot,
      familyMembers: familyMembers ?? this.familyMembers,
      vehicles: vehicles ?? this.vehicles,
      visitorNotifications:
      visitorNotifications ?? this.visitorNotifications,
      packageNotifications:
      packageNotifications ?? this.packageNotifications,
      announcementAlerts: announcementAlerts ?? this.announcementAlerts,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    mobile,
    email,
    dateOfBirth,
    emergencyContactName,
    emergencyContactMobile,
    photoUrl,
    active,
    buildingId,
    createdAt,
    createdBy,
    flatId,
    flatNo,
    residentEmail,
    residentFirstName,
    residentId,
    residentLastName,
    residentMobile,
    residentRole,
    societyId,
    updatedAt,
    updatedBy,
    residentType,
    moveInDate,
    moveOutDate,
    parkingSlot,
    familyMembers,
    vehicles,
    visitorNotifications,
    packageNotifications,
    announcementAlerts,
  ];

  static Future<ProfileModel?> fromJson(Map<String, dynamic> map) async {
    if (map.isEmpty) return null;

    final familyMembers =
        map['familyMembers'] as List<dynamic>? ?? const [];
    final vehicles = map['vehicles'] as List<dynamic>? ?? const [];
    String? readString(String key) => map[key]?.toString();

    return ProfileModel(
      fullName: readString('fullName') ?? '',
      mobile: readString('mobile') ??
          readString('residentMobile') ??
          '',
      email: readString('email') ??
          readString('residentEmail'),
      dateOfBirth: readString('dateOfBirth'),
      emergencyContactName: readString('emergencyContactName'),
      emergencyContactMobile: readString('emergencyContactMobile'),
      photoUrl: readString('photoUrl'),
      active: map['active'] as bool?,
      buildingId: map['buildingId'] as int?,
      createdAt: readString('createdAt'),
      createdBy: map['createdBy'] as int?,
      flatId: map['flatId'] as int?,
      flatNo: readString('flatNo'),
      residentEmail: readString('residentEmail'),
      residentFirstName: readString('residentFirstName'),
      residentId: map['residentId'] as int?,
      residentLastName: readString('residentLastName'),
      residentMobile: readString('residentMobile'),
      residentRole: readString('residentRole'),
      societyId: readString('societyId'),
      updatedAt: readString('updatedAt'),
      updatedBy: map['updatedBy'] as int?,
      residentType: readString('residentType') ?? 'OWNER',
      moveInDate: readString('moveInDate'),
      moveOutDate: readString('moveOutDate'),
      parkingSlot: readString('parkingSlot'),
      familyMembers: familyMembers
          .map((item) => FamilyMemberModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      ))
          .toList(),
      vehicles: vehicles
          .map((item) => VehicleModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      ))
          .toList(),
      visitorNotifications:
      (map['visitorNotifications'] as bool?) ?? true,
      packageNotifications:
      (map['packageNotifications'] as bool?) ?? true,
      announcementAlerts:
      (map['announcementAlerts'] as bool?) ?? true,
    );

  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'mobile': mobile,
    'email': email,
    'dateOfBirth': dateOfBirth,
    'emergencyContactName': emergencyContactName,
    'emergencyContactMobile': emergencyContactMobile,
    'photoUrl': photoUrl,
    'active': active,
    'buildingId': buildingId,
    'createdAt': createdAt,
    'createdBy': createdBy,
    'flatId': flatId,
    'flatNo': flatNo,
    'residentEmail': residentEmail,
    'residentFirstName': residentFirstName,
    'residentId': residentId,
    'residentLastName': residentLastName,
    'residentMobile': residentMobile,
    'residentRole': residentRole,
    'societyId': societyId,
    'updatedAt': updatedAt,
    'updatedBy': updatedBy,
    'residentType': residentType,
    'moveInDate': moveInDate,
    'moveOutDate': moveOutDate,
    'parkingSlot': parkingSlot,
    'familyMembers': familyMembers.map((item) => item.toJson()).toList(),
    'vehicles': vehicles.map((item) => item.toJson()).toList(),
    'visitorNotifications': visitorNotifications,
    'packageNotifications': packageNotifications,
    'announcementAlerts': announcementAlerts,
  };


}