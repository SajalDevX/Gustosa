import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/pages/welcome_screen.dart';

import '../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../domain/usecases/fetch_user_use_case.dart';
import '../../domain/usecases/insert_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../bloc/auth_bloc/bloc.dart';
import '../bloc/user_signup/bloc.dart';

class WelcomePageBuilder extends StatelessWidget{
  const WelcomePageBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              sl<FetchUserUseCase>(),
              sl<UpdateUserUseCase>(),
              sl<InsertUserUseCase>(),
            ),
          ),BlocProvider<SignUpPageBloc>(
            create: (_) => SignUpPageBloc(
              sl<FetchUserUseCase>(),
              sl<UpdateUserUseCase>(),
            ),
          ),        ],
        child: const WelcomeScreen()
    );
  }
}