import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source_impl.dart';
import '../../../platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import '../../../platforms/mobile/auth/domain/repository/supabase_auth_repository.dart';
import '../../../platforms/mobile/auth/domain/usecases/get_current_user_usecase.dart';
import '../../../platforms/mobile/auth/domain/usecases/signin_with_email_usecase.dart';
import '../../../platforms/mobile/auth/domain/usecases/signout_usecase.dart';
import '../../../platforms/mobile/auth/domain/usecases/signup_with_email_usecase.dart';
import '../../../platforms/mobile/auth/presentation/bloc/bloc.dart';

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