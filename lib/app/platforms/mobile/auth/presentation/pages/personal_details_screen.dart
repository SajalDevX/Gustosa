import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/user_signup/bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/customProgressIndicator.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';

import '../../../../../shared/core/inject_dependency/dependencies.dart';

class AuthSignUpPage extends StatefulWidget {
  const AuthSignUpPage({super.key});

  @override
  State<AuthSignUpPage> createState() => _AuthSignUpPageState();
}

class _AuthSignUpPageState extends State<AuthSignUpPage> {
  final authController = sl<SignUpPageBloc>();

  @override
  void dispose() {
    authController.firstNameController.dispose();
    authController.lastNameController.dispose();
    authController.firstNameFocusNode.dispose();
    authController.lastNameFocusNode.dispose();
    super.dispose();
  }

  bool _onWillPop() {
    authController.add(OnBackPressedEvent(context));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => authController,
      child: PopScope(
        canPop: _onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Personal Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                authController.add(OnBackPressedEvent(context));
              },
            ),
          ),
          body: BlocConsumer<SignUpPageBloc, SignUpPageState>(
            listener: (context, state) {
              if (state is OnNextPageState) {
                Get.toNamed(AppRoutes.home);
              } else if (state is SigningUpErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error during signup')),
                );
              }
            },
            builder: (context, state) {
              if (state is SigningUpState) {
                return  const Center(
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: CustomProgressIndicator(),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: authController.firstNameController,
                      focusNode: authController.firstNameFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: authController.lastNameController,
                      focusNode: authController.lastNameFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: authController.emailOrPhoneController,
                      focusNode: authController.emailFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Email or Phone Number',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Trigger the sign-up event when the button is pressed
                        authController.add(SignUpEvent(context));
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
