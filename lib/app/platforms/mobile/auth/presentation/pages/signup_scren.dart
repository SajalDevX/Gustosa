import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../domain/usecases/fetch_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../bloc/user_signup/bloc.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpPageBloc(
        sl<FetchUserUseCase>(),
        sl<UpdateUserUseCase>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Complete Your Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<SignUpPageBloc, SignUpPageState>(
            listener: (context, state) {
              if (state is OnNextPageState) {
                Navigator.pushNamed(context, '/home');
              }
            },
            child: BlocBuilder<SignUpPageBloc, SignUpPageState>(
              builder: (context, state) {
                final bloc = context.read<SignUpPageBloc>();

                return Column(
                  children: [
                    TextField(
                      controller: bloc.firstNameController,
                      focusNode: bloc.firstNameFocusNode,
                      decoration: const InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      controller: bloc.lastNameController,
                      focusNode: bloc.lastNameFocusNode,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                    TextField(
                      controller: bloc.emailOrPhoneController,
                      focusNode: bloc.emailFocusNode,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        bloc.add(SignUpEvent(context));
                      },
                      child: const Text("Complete Sign-Up"),
                    ),
                    if (state is SigningUpState) const CircularProgressIndicator(),
                    if (state is SigningUpErrorState)
                      const Text("An error occurred. Please try again."),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
