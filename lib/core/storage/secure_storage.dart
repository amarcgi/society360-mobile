// lib/core/storage/secure_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  static const _storage = FlutterSecureStorage();

  // JWT Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // User Info
  static Future<void> saveRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }

  static Future<void> saveSocietyId(
      String societyId) async {
    await _storage.write(
        key: 'society_id', value: societyId);
  }

  static Future<String?> getSocietyId() async {
    return await _storage.read(key: 'society_id');
  }

  // Clear everything on logout
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> saveMobile(String mobileNumber) async{
    _storage.write(
        key: 'mobileNumber', value: mobileNumber);
  }

  static Future<void> saveUserId(String string)  async {
    _storage.write(
        key: 'userId', value: string);
  }

  static const _keyProfileDone = 'Profile_done';
  static const _keyResidentId     = 'resident_id';

  static Future<void> saveProfileDone(String v) =>
      _storage.write(
          key: _keyProfileDone, value: v);

  static Future<String?> getProfileDone() =>
      _storage.read(key: _keyProfileDone);

  static Future<void> saveResidentId(String v) =>
      _storage.write(
          key: _keyResidentId, value: v);

  static Future<String?> getResidentId() =>
      _storage.read(key: _keyResidentId);
}