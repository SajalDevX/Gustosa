import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/social_button.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  List<LoginMode> socialMethods = [
    LoginMode.google,
    LoginMode.phone,
  ];

  @override
  void initState() {
    super.initState();
    sl<AuthBloc>().add(const InitializeEvent(true));
    if (Platform.isIOS) {
      socialMethods.insert(1, LoginMode.apple);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => sl<AuthBloc>().add(OnBackClickedEvent(context)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 75.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFF6223C),
                        Color(0xFFA342FF),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/hushh_s_logo_v1.png',
                                color: Colors.white,
                                width: 33.w,
                                fit: BoxFit.fill,
                                height: 36.w * 1.2,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'hushh 🤫',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: -1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Unlock the power of your data',
                                style:  Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: -1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                            children: List.generate(
                                socialMethods.length,
                                (index) => SocialButton(
                                        loginMode: socialMethods[index])
                                    .animate(delay: (300 * index).ms)
                                    .fade(duration: 700.ms)
                                    .moveX(duration: 800.ms))),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const Spacer(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
