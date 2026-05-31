// lib/features/Profile/data/repositories/
//              profile_repository_impl.dart





import '../../screen/profile/models/profile_model.dart';
import '../datsource/profile_remote_datasource.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {

  final ProfileRemoteDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<void> saveProfile(
      ProfileModel data) async {
    await _dataSource.saveProfile(data);
  }
}