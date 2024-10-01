part of 'dependencies.dart';

Future<void> injectUseCases() async {
  sl.registerSingleton(FetchAgentsUseCase(sl()));
  sl.registerSingleton(FetchUsersUseCase(sl()));
  sl.registerSingleton(InsertAgentUseCase(sl()));
  sl.registerSingleton(InsertUserUseCase(sl()));
  sl.registerSingleton(UpdateUserUseCase(sl()));
}