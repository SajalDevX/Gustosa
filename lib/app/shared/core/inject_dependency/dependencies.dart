import 'package:get_it/get_it.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/repository/supabase_auth_repository.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import '../../../platforms/mobile/auth/data/data_sources/supabase_auth_data_source_impl.dart';
import '../../../platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/fetch_users_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/insert_user_use_case.dart';
import '../../../platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import '../../../platforms/mobile/auth/presentation/bloc/user_signup/bloc.dart';
import '../backend_controller/auth_controller/auth_controller_impl.dart';

part 'blocs.dart';

part 'data_sources.dart';

part 'repositories.dart';

part 'usecases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async{
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
Future<SignUpPageBloc> resetSignUpPageBlocInstance() async {
  if (sl.isRegistered<SignUpPageBloc>()) {
    await sl.unregister<SignUpPageBloc>();
  }
  sl.registerSingleton<SignUpPageBloc>(SignUpPageBloc(
    sl(),
    sl(),
  ));
  return sl<SignUpPageBloc>();
}