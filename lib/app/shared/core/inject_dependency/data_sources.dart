part of 'dependencies.dart';

Future<void> injectDataSources() async {
  sl.registerLazySingleton<SupabaseAuthDataSource>(
      () => SupabaseAuthDataSourceImpl());
}
