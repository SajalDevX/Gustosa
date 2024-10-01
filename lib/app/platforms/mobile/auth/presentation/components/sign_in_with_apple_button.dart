import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';

class SignInWithAppleButton extends StatelessWidget {
  const SignInWithAppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<AuthBloc>();
    return Expanded(
      child: InkWell(
        onTap: () => controller.add(AuthenticateWithAppleEvent(context)),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffD4D4D4))),
          child: BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                return Center(
                    child: state is AuthenticatingWithAppleState
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/appleButton.svg"),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Sign in with Apple",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )
                            ],
                          ));
              }),
        ),
      ),
    );
  }
}
