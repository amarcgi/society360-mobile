import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API REQUEST: ${options.method} ${options.uri}');
      //debugPrint('Query: ${_encode(options.queryParameters)}');
      debugPrint('Query: ${options.queryParameters}');
      //debugPrint('Headers: ${_encode(options.headers)}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Payload: ${_format(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'API RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('Payload: ${_format(response.data)}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'API ERROR: ${error.response?.statusCode} '
            '${error.requestOptions.uri}',
      );
      debugPrint('Payload: ${_format(error.response?.data)}');
      debugPrint('Message: ${error.message}');
    }
    handler.next(error);
  }

  String _format(Object? value) {
    if (value is FormData) {
      final data = {
        'fields': value.fields.map((field) => {field.key: field.value}).toList(),
        'files': value.files.map((file) => {'field': file.key, 'value': '<file>'}).toList(),
      };
      //return _encode(data);
      return data.toString();
    }
    if (value is String) {
      try {
        //return _encode(jsonDecode(value));
        return value;
      } on FormatException {
        return value;
      }
    }
    //return _encode(value);
    return value.toString();
  }
  }

  /*String _encode(Object? value) => jsonEncode(_redact(value));

  Object? _redact(Object? value, [String? key]) {
    final normalizedKey =
        key?.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '') ?? '';

    const privateKeyParts = [
      'authorization', 'cookie', 'token', 'password', 'secret', 'otp',
      'mobile', 'phone', 'email', 'address', 'dateofbirth',
    ];
    if (privateKeyParts.any(normalizedKey.contains)) return '[REDACTED]';

    if (value is Map) {
      return value.map(
            (key, value) => MapEntry(key.toString(), _redact(value, key.toString())),
      );
    }
    if (value is List) {
      return value.map((item) => _redact(item)).toList();
    }
    return value;
  }
}*/