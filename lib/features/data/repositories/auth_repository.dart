import '../../../../core/storage/secure_storage.dart';
import '../datsource/auth_remote_datasource.dart';
import '../model/otp_request_model.dart';

abstract class AuthRepository {
  Future<void> requestOtp(String mobile);
  Future<LoginResponseModel> verifyOtp(
      String mobile, String otp, String role);
}
class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<void> requestOtp(String mobile) async {
    await _dataSource.requestOtp(
        OtpRequestModel(mobileNumber: mobile));
  }

  @override
  Future<LoginResponseModel> verifyOtp(
      String mobile, String otp,
      String role) async {

    final response = await _dataSource.verifyOtp(
      VerifyOtpModel(
        mobileNumber: mobile,
        otp: otp,
        role: role,
      ),
    );

    // ✅ Save to secure storage on success
    await SecureStorage.saveToken(response.token);
    await SecureStorage.saveRole(response.role);
    await SecureStorage.saveMobile(
        response.mobileNumber);
    if (response.societyId != null) {
      await SecureStorage.saveSocietyId(
          response.societyId!);
    }
    if (response.userId != null) {
      await SecureStorage.saveUserId(
          response.userId.toString());
    }

    return response;
  }
}
