class OtpRequestModel {
  final String mobileNumber;

  const OtpRequestModel({required this.mobileNumber});

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
  };
}

// lib/features/auth/data/models/verify_otp_model.dart

class VerifyOtpModel {
  final String mobileNumber;
  final String otp;
  final String role;

  const VerifyOtpModel({
    required this.mobileNumber,
    required this.otp,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'mobileNumber': mobileNumber,
    'otp': otp,
    'role': role,
  };
}

// lib/features/auth/data/models/login_response_model.dart

class LoginResponseModel {
  final String token;
  final String role;
  final String mobileNumber;
  final String? societyId;
  final int? userId;
  final int expiresIn;

  const LoginResponseModel({
    required this.token,
    required this.role,
    required this.mobileNumber,
    this.societyId,
    this.userId,
    required this.expiresIn,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json) {
    return LoginResponseModel(
      token:        json['token'] ?? '',
      role:         json['role']  ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      societyId:    json['societyId'],
      userId:       json['userId'],
      expiresIn:    json['expiresIn'] ?? 0,
    );
  }
}
