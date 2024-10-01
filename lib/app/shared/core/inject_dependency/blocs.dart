part of 'dependencies.dart';

Future<void> injectBlocs() async {
  sl.registerSingleton(SplashPageBloc());

  sl.registerSingleton(HomePageBloc(sl()));

  sl.registerSingleton(SignUpPageBloc(
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(OnboardingPageBloc());

  sl.registerSingleton(AuthBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(AgentSignUpPageBloc(sl()));
}
