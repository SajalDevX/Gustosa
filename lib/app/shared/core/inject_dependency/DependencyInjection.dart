import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/AuthDataSource.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/AuthDataSourceImpl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/GetCurrentUserUseCase.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/SignInWithEmailUseCase.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/SignOutUseCase.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/SignUpWithEmailUseCase.dart';
import '../../../platforms/mobile/auth/data/repository_impl/AuthRepositoryImpl.dart';
import '../../../platforms/mobile/auth/domain/repository/AuthRepository.dart';
import '../../../platforms/mobile/auth/presentation/bloc/AuthBloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  sl.registerFactory(() => AuthBloc(sl(), sl(),sl(),sl()));
}
