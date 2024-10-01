import 'package:get_it/get_it.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/supabase_auth_data_source_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/splash/presentation/bloc/onboarding_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';
import '../../../platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/fetch_users_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/insert_agent_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/insert_user_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import '../../../platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import '../../../platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import '../backend_controller/auth_controller/auth_controller_impl.dart';
import '../error_handler/dev_tool.dart';


part 'blocs.dart';

part 'data_sources.dart';

part 'repositories.dart';

part 'usecases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async{
  sl.registerSingleton<Talker>(customLogger());
  sl<Talker>().cleanHistory();

  sl.registerSingleton<AuthController>(AuthControllerImpl());
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