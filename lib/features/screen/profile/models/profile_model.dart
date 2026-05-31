import 'package:equatable/equatable.dart';
import 'vehicle_model.dart';

import 'family_member_model.dart';

// Holds all data across all 4 steps
class ProfileModel extends Equatable {

  // Step 1 — Personal
  final String fullName;
  final String mobile;
  final String? email;
  final String? dateOfBirth;
  final String? emergencyContactName;
  final String? emergencyContactMobile;
  final String? photoUrl;

  // Step 2 — Flat
  final String residentType;  // OWNER/TENANT/FAMILY
  final String? moveInDate;
  final String? moveOutDate;
  final String? parkingSlot;

  // Step 3 — Family & Vehicles
  final List<FamilyMemberModel> familyMembers;
  final List<VehicleModel> vehicles;

  // Step 3 — Preferences
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
    this.residentType = 'OWNER',
    this.moveInDate,
    this.moveOutDate,
    this.parkingSlot,
    this.familyMembers = const [],
    this.vehicles      = const [],
    this.visitorNotifications  = true,
    this.packageNotifications  = true,
    this.announcementAlerts    = true,
  });

  ProfileModel copyWith({
    String? fullName, String? mobile,
    String? email, String? dateOfBirth,
    String? emergencyContactName,
    String? emergencyContactMobile,
    String? photoUrl, String? residentType,
    String? moveInDate, String? moveOutDate,
    String? parkingSlot,
    List<FamilyMemberModel>? familyMembers,
    List<VehicleModel>? vehicles,
    bool? visitorNotifications,
    bool? packageNotifications,
    bool? announcementAlerts,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      mobile:   mobile   ?? this.mobile,
      email:    email    ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContactName:
      emergencyContactName ??
          this.emergencyContactName,
      emergencyContactMobile:
      emergencyContactMobile ??
          this.emergencyContactMobile,
      photoUrl:     photoUrl     ?? this.photoUrl,
      residentType: residentType ?? this.residentType,
      moveInDate:   moveInDate   ?? this.moveInDate,
      moveOutDate:  moveOutDate  ?? this.moveOutDate,
      parkingSlot:  parkingSlot  ?? this.parkingSlot,
      familyMembers: familyMembers ?? this.familyMembers,
      vehicles:  vehicles  ?? this.vehicles,
      visitorNotifications:
      visitorNotifications ??
          this.visitorNotifications,
      packageNotifications:
      packageNotifications ??
          this.packageNotifications,
      announcementAlerts:
      announcementAlerts ??
          this.announcementAlerts,
    );
  }

  @override
  List<Object?> get props => [
    fullName, mobile, email, residentType,
    moveInDate, familyMembers, vehicles,
  ];
}

