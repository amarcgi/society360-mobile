// lib/core/constants/api_constants.dart

class ApiConstants {

  // ── Change this to your machine's IP when testing
  // on real device (localhost won't work on phone)
  static const String baseUrl =
      'http://10.0.2.2:8080';  // your IP

  // ── Auth endpoints
  static const String requestOtp =
      '/api/auth/request-otp';
  static const String verifyOtp =
      '/api/auth/verify-otp';

  // ── Society endpoints
  static const String announcements =
      '/api/announcements';
  static const String complaints =
      '/api/raise_complains';
  static const String invoices =
      '/api/invoices';
  static const String visitors =
      '/api/visitors';
  static const String packages =
      '/api/packages';
}