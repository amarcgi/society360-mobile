// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';

class ApiClient {

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage();
  late final Dio dio;

  void init() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    // ✅ JWT injected automatically on every request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(
              key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] =
            'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // 401 → token expired → go to login
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: 'jwt_token');
            // Navigate to login
            // GoRouter.of(context).go('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }
}