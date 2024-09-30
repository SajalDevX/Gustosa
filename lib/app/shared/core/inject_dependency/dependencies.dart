import 'package:get_it/get_it.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/supabase_auth_data_source_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';


part 'blocs.dart';

part 'data_sources.dart';

part 'repositories.dart';

part 'usecases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async{
  await injectDataSources();
  await injectRepositories();
  await injectUseCases();
  await injectBlocs();
}
Future<void> clearAndReinitializeDependencies() async {
  await sl.reset();
  await initializeDependencies();
}

Future<AuthBloc> resetAuthPageBlocInstance() async {
  if (sl.isRegistered<AuthBloc>()) {
    await sl.unregister<AuthBloc>();
  }
  sl.registerSingleton<AuthBloc>(AuthBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  return sl<AuthBloc>();
}

Future<SignUpPageBloc> resetSignUpPageBlocInstance() async {
  if (sl.isRegistered<SignUpPageBloc>()) {
    await sl.unregister<SignUpPageBloc>();
  }
  sl.registerSingleton<SignUpPageBloc>(SignUpPageBloc(
    sl(),
    sl(),
    sl(),
  ));
  return sl<SignUpPageBloc>();
}