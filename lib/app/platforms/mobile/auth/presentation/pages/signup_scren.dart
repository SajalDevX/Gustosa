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
          sl<UpdateUserUseCase>()
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Complete Your Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SignUpPageBloc, SignUpPageState>(
            builder: (context, state) {
              final bloc = context.read<SignUpPageBloc>();

              return Column(
                children: [
                  TextField(
                    controller: bloc.firstNameController,
                    focusNode: bloc.firstNameFocusNode,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: bloc.lastNameController,
                    focusNode: bloc.lastNameFocusNode,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: bloc.emailOrPhoneController,
                    focusNode: bloc.emailFocusNode,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(SignUpEvent(context));
                    },
                    child: Text("Complete Sign-Up"),
                  ),
                  if (state is SigningUpState) CircularProgressIndicator(),
                  if (state is SigningUpErrorState)
                    Text("An error occurred. Please try again."),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
