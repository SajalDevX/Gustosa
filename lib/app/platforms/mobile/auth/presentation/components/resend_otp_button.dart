import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../../../shared/core/inject_dependency/dependencies.dart';

class ResendOtpButton extends StatelessWidget {
  const ResendOtpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is AuthResendOtpCountdown) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Countdown(
                seconds: state.secondsRemaining, // Countdown seconds from the state
                build: (BuildContext context, double time) {
                  if (time == 0) {
                    // When countdown finishes, show "Resend Now" button
                    return InkWell(
                      onTap: () {
                        // Trigger the resend OTP event
                        authBloc.add(AuthResendOtpRequested(
                           authBloc.phoneNumber, // Get the phone number from AuthBloc
                           context,
                        ));
                      },
                      child: Text(
                        "Resend Now",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    );
                  } else {
                    // Show the countdown while it's still running
                    return RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Didn't receive?",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xffA3A3A3),
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: ' Resend',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xffA3A3A3),
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: ' in ${time.toInt()} seconds',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xffA3A3A3),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                interval: Duration(seconds: 1), // Countdown updates every second
              ),
            ),
          );
        } else if (state is AuthResendOtpEnable) {
          // When countdown is finished, enable the resend button
          return InkWell(
            onTap: () {
              authBloc.add(AuthResendOtpRequested(
                 authBloc.phoneNumber,
                 context,
              ));
            },
            child: Text(
              "Resend Now",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          );
        } else if (state is AuthError) {
          // Show error message if something went wrong
          return Text(
            "Error: ${state.message}",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          );
        } else {
          // Default state, can be an initial state
          return SizedBox.shrink();
        }
      },
    );
  }
}
