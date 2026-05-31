// lib/features/Profile/domain/usecases/
//              save_profile_usecase.dart


// UseCase = single responsibility
// Wraps repository call
// Makes BLoC cleaner — BLoC calls usecase not repo directly

import '../../../data/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class SaveProfileUseCase {

  final ProfileRepository _repository;

  SaveProfileUseCase(this._repository);

  Future<void> call(ProfileModel data) async {
    // Validate before calling backend
    if (data.fullName.trim().isEmpty) {
      throw Exception('Full name is required');
    }
    if (data.moveInDate == null ||
        data.moveInDate!.isEmpty) {
      throw Exception('Move-in date is required');
    }

    await _repository.saveProfile(data);
  }
}