class SocietyDashBoardDetails {
  final int buildingId;
  final String buildingName;
  final int flatId;
  final String flatNo;
  final String flatType;
  final String registeredMobileNo;
  final String residentEmail;
  final String residentFirstName;
  final String residentLastName;
  final String residentType;
  final String? societyAddress;
  final String societyId;
  final String societyName;

  const SocietyDashBoardDetails({
    required this.buildingId,
    required this.buildingName,
    required this.flatId,
    required this.flatNo,
    required this.flatType,
    required this.registeredMobileNo,
    required this.residentEmail,
    required this.residentFirstName,
    required this.residentLastName,
    required this.residentType,
    this.societyAddress,
    required this.societyId,
    required this.societyName,
  });

  factory SocietyDashBoardDetails.fromJson(Map<String, dynamic> json) {
    return SocietyDashBoardDetails(
      buildingId: json['buildingId'] as int,
      buildingName: json['buildingName'] as String,
      flatId: json['flatId'] as int,
      flatNo: json['flatNo'] as String,
      flatType: json['flatType'] as String,
      registeredMobileNo: json['registeredMobileNo'].toString(),
      residentEmail: json['residentEmail'] as String,
      residentFirstName: json['residentFirstName'] as String,
      residentLastName: json['residentLastName'] as String,
      residentType: json['residentType'] as String,
      societyAddress: json['societyAddress'] as String?,
      societyId: json['societyId'] as String,
      societyName: json['societyName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildingId': buildingId,
      'buildingName': buildingName,
      'flatId': flatId,
      'flatNo': flatNo,
      'flatType': flatType,
      'registeredMobileNo': registeredMobileNo,
      'residentEmail': residentEmail,
      'residentFirstName': residentFirstName,
      'residentLastName': residentLastName,
      'residentType': residentType,
      'societyAddress': societyAddress,
      'societyId': societyId,
      'societyName': societyName,
    };
  }
}