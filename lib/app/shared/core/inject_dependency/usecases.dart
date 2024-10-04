part of 'dependencies.dart';

Future<void> injectUseCases() async {
  sl.registerSingleton(FetchUserUseCase(sl()));
  sl.registerSingleton(FetchUsersUseCase(sl()));
  sl.registerSingleton(InsertUserUseCase(sl()));
  sl.registerSingleton(UpdateUserUseCase(sl()));
}