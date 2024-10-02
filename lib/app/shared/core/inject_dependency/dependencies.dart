import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source_impl.dart';
import '../../../platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import '../../../platforms/mobile/auth/domain/repository/supabase_auth_repository.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton<SupabaseAuthDataSource>(() => SupabaseAuthDataSourceImpl());

  sl.registerLazySingleton<SupabaseAuthRepository>(() => SupabaseAuthRepositoryImpl(sl()));


}