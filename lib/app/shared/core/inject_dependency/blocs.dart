part of 'dependencies.dart';

Future<void> injectBlocs() async {
  sl.registerSingleton(AuthBloc(
    sl(),
    sl(),
    sl(),
  ));
}
