// lib/features/Profile/data/repositories/
//              profile_repository_impl.dart
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../screen/profile/models/profile_model.dart';
import '../datsource/profile_remote_datasource.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {

  /*final ProfileRemoteDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);*/

  Dio get _dio => ApiClient().dio;

  @override
  Future<void> saveProfile(
      ProfileModel data) async {
    //await _dataSource.saveProfile(data);
    try {

      // ── Step 1: Get IDs from secure storage ──
      final societyId  = await SecureStorage.getSocietyId();
      final residentId = await SecureStorage.getResidentId();

      // ── Step 2: Update resident profile ───────
      // PATCH /api/residents/{residentId}
      await _dio.patch(
        '/api/residents/$residentId',
        data: {
          'fullName':               data.fullName,
          'residentEmail':          data.email,
          'residentType':           data.residentType,
          'moveInDate':             data.moveInDate,
          'moveOutDate':            data.moveOutDate,
          'dateOfBirth':            data.dateOfBirth,
          'emergencyContactName':   data.emergencyContactName,
          'emergencyContactMobile': data.emergencyContactMobile,
          'parkingSlot':            data.parkingSlot,
        },
      );

      // ── Step 3: Save each family member ───────
      // POST /api/family-members
      for (final member in data.familyMembers) {
        await _dio.post(
          '/api/family-members',
          data: {
            'residentId': residentId,
            'societyId':  societyId,
            ...member.toJson(),
          },
        );
      }

      // ── Step 4: Save each vehicle ─────────────
      // POST /api/vehicles
      for (final vehicle in data.vehicles) {
        await _dio.post(
          '/api/vehicles',
          data: {
            'residentId': residentId,
            'societyId':  societyId,
            ...vehicle.toJson(),
          },
        );
      }

    } on DioException catch (e) {
      final message = e.response?.data?['message']
          ?? e.message
          ?? 'Failed to save profile';
      throw Exception(message);
    }
  }

  @override
  Future<ProfileModel?> getMyProfileByMobileNo(String mobile) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.profile}${Uri.encodeComponent(mobile)}',
      );

      if (response.data == null) return null;

      final data = response.data;
      if (data is! Map) {
        throw const FormatException(
          'Unexpected response while loading resident profile',
        );
      }
      return ProfileModel.fromJson(Map<String, dynamic>.from(data));

    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;

      final responseData = e.response?.data;
      final message = responseData is Map
          ? responseData['message']?.toString()
          : null;

      throw Exception(
        message ?? e.message ?? 'Failed to load resident profile',
      );
    }
  }
}