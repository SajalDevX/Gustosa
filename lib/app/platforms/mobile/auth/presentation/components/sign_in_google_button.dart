import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import '../../../../../shared/core/inject_dependency/dependencies.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<AuthBloc>();
    return Expanded(
      child: InkWell(
        onTap: () => controller.add(AuthSignInWithGoogleRequested(context)),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffD4D4D4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset("assets/googleButton.svg"),
              ),
              const Center(
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
