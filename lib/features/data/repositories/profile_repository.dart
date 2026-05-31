// lib/features/Profile/domain/repositories/
//              profile_repository.dart







import '../../screen/profile/models/profile_model.dart';

abstract class ProfileRepository {

  // Save complete resident profile to backend
  // Calls multiple APIs internally:
  // POST /api/residents        → resident profile
  // POST /api/vehicles         → each vehicle
  // POST /api/family-members   → each family member
  Future<void> saveProfile(ProfileModel data);
}