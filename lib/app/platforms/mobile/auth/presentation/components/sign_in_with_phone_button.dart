import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';

import '../../../../../shared/core/inject_dependency/dependencies.dart';

class SignInWithPhoneButton extends StatelessWidget {
  final String phoneNumber;

  const SignInWithPhoneButton({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();

    return InkWell(
      onTap: () {
        // Dispatch the AuthSignInWithPhoneRequested event with the entered phone number
        authBloc.add(AuthSignInWithPhoneRequested(phoneNumber, context));
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0XFFA342FF),
            Color(0XFFE54D60),
          ]),
          borderRadius: BorderRadius.circular(7),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            return const Center(
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
