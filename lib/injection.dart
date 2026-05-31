
// lib/injection.dart
// Dependency Injection using GetIt

import 'package:get_it/get_it.dart';

import 'features/data/datsource/auth_remote_datasource.dart';
import 'features/data/datsource/profile_remote_datasource.dart';
import 'features/data/repositories/auth_repository.dart';
import 'features/data/repositories/profile_repository.dart';
import 'features/data/repositories/profile_repository_impl.dart';
import 'features/screen/login/bloc/auth_bloc.dart';
import 'features/screen/profile/bloc/profile_bloc.dart';
import 'features/screen/profile/widgets/save_profile_usecase.dart';







final sl = GetIt.instance;

Future<void> initDependencies() async {

  // ── BLoC ─────────────────────────────────
  // factory = new instance each time
  sl.registerFactory(() => AuthBloc(sl()));

  // ── Repositories ─────────────────────────
  // singleton = same instance every time
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl()));

  // ── Data Sources ─────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl());


  // Add to lib/injection.dart

// lib/injection.dart — add these

// UseCase
  sl.registerLazySingleton(
          () => SaveProfileUseCase(sl()));

// BLoC — now takes UseCase not Repository
  sl.registerFactory(
          () => ProfileBloc(sl<ProfileRepository>()));

// Repository
  sl.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(sl()));

// DataSource
  sl.registerLazySingleton<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSourceImpl());


}
