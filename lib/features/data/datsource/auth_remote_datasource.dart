import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../model/otp_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(OtpRequestModel model);
  Future<LoginResponseModel> verifyOtp(
      VerifyOtpModel model);
}

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {

  final Dio _dio = ApiClient().dio;

  @override
  Future<void> requestOtp(
      OtpRequestModel model) async {
    try {
      await _dio.post(
        ApiConstants.requestOtp,
        data: model.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<LoginResponseModel> verifyOtp(
      VerifyOtpModel model) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: model.toJson(),
      );
      return LoginResponseModel.fromJson(
          response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final message = e.response?.data?['message']
        ?? e.message
        ?? 'Something went wrong';
    return Exception(message);
  }
}
