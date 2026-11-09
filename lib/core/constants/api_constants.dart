// lib/core/constants/api_constants.dart

class ApiConstants {

  // ── Change this to your machine's IP when testing
  // on real device (localhost won't work on phone)
  static const String context_path='/society360';
  static const String server_URL='http://10.0.2.2:8080';
  static const String baseUrl =server_URL + context_path;

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

  //profile endpoints
  static const String profile =
      '/api/residents/me/';
  //DashBaord
  static const String dashBoard = '/api/resident_dashboard/';

}