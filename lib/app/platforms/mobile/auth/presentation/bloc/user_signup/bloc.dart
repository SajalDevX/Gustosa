import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:toastification/toastification.dart';
import '../../../../../../shared/config/constants/enums.dart';
import '../../../../../../shared/config/routes/routes.dart';
import '../../../../../../shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import '../../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../../../../../shared/core/local_storage/local_storage.dart';
import '../../../../../../shared/core/utils/toast_manager.dart';
import '../../../domain/usecases/fetch_user_use_case.dart';
import '../../../domain/usecases/update_user_use_case.dart';

part 'event.dart';

part 'state.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvent, SignUpPageState> {
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  SignUpPageBloc(
    this.fetchUserUseCase,
    this.updateUserUseCase,
  ) : super(SignUpPageInitialState()) {
    on<OnBackPressedEvent>(onBackPressedEvent);
    on<SignUpEvent>(signUpEvent);
  }

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailOrPhoneController = TextEditingController();
  final auth = sl<AuthController>();

  FutureOr<void> onBackPressedEvent(
      OnBackPressedEvent event, Emitter<SignUpPageState> emit) async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushNamedAndRemoveUntil(
        event.context, AppRoutes.mainAuth, (route) => false);
  }

  FutureOr<void> signUpEvent(
      SignUpEvent event, Emitter<SignUpPageState> emit) async {
    showToast(String message) {
      ToastManager(Toast(title: message, type: ToastificationType.error))
          .show(event.context);
    }

    emit(SigningUpState());

    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String email = emailOrPhoneController.text;

    if (firstName.isEmpty) {
      emit(SigningUpErrorState());
      showToast("Please enter your first name");
      return;
    }
    if (lastName.isEmpty) {
      emit(SigningUpErrorState());
      showToast("Please enter your last name");
      return;
    }

    if (sl<AuthBloc>().isPhoneLogin) {
      if (email.isEmpty ||
          !RegExp(r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+\.([a-zA-Z0-9!#$%&*+/=?^_`{|}~-]+)$')
              .hasMatch(email.trim())) {
        emit(SigningUpErrorState());
        showToast("Invalid email");
        return;
      }
    } else {
      if (email.isEmpty) {
        emit(SigningUpErrorState());
        showToast("Invalid phone number");
        return;
      }
    }

    Future<void> onUserSignUp() async {
      final user = UserEntity(
        gustId: FirebaseAuth.instance.currentUser!.uid,
        email: FirebaseAuth.instance.currentUser!.email,
        onboardStatus: OnboardStatus.signed_up,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: !sl<AuthBloc>().isPhoneLogin
            ? emailOrPhoneController.text.toLowerCase()
            : sl<AuthBloc>().phoneController.text,
      );
      AppLocalStorage.updateUser(user);
      AppLocalStorage.updateGustId(user.gustId!);
      final result2 = await updateUserUseCase(user: user, uid: user.gustId!);
      result2.fold((l) {}, (r) async {
        AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.loggedIn);
      });
    }

    onUserSignUp();
    emit(OnNextPageState());
  }
}
