import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/config/routes/routes.dart';
import '../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../domain/usecases/fetch_user_use_case.dart';
import '../../domain/usecases/insert_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../bloc/auth_bloc/bloc.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
          sl<FetchUserUseCase>(),
          sl<UpdateUserUseCase>(),
          sl<InsertUserUseCase>()
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is AuthenticationCompleteWithGoogleState) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignInWithGoogleRequested(context));
                  },
                  child: Text("Sign In with Google"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to phone authentication screen
                    Navigator.pushNamed(context, AppRoutes.userSignUp);
                  },
                  child: Text("Sign In with Phone Number"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
