import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';

class AgentStatusPage extends StatelessWidget {
  const AgentStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    AgentApprovalStatus status =
        ModalRoute.of(context)!.settings.arguments as AgentApprovalStatus;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.watch_later_rounded, size: 30.w),
                    const SizedBox(height: 16),
                    Text(
                      status == AgentApprovalStatus.pending
                          ? "Approval Pending!"
                          : "Approval Denied!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      status == AgentApprovalStatus.pending
                          ? "Contact the brand admins to expedite the process. You are currently in the approval queue."
                          : "Unfortunately, your request for approval has been denied. Please review the provided guidelines and make necessary adjustments before reapplying.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          RichText(
              text: TextSpan(
            children: [
              const TextSpan(text: 'Continue using Hushh Wallet? '),
              TextSpan(
                  text: 'click here',
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0XFFA342FF)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      sl<HomePageBloc>()
                          .add(UpdateUserRoleEvent(Entity.user, context));
                    }),
            ],
            style: const TextStyle(color: Colors.black, fontSize: 16),
          )),
          const SizedBox(height: 32)
        ],
      ),
    );
  }
}
