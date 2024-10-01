part of 'dependencies.dart';

Future<void> injectRepositories() async {
  sl.registerSingleton(AuthRepositoryImpl(sl()));

}