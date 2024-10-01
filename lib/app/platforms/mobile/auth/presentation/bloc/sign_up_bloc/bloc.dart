

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/agent_model.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_model.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/insert_agent_use_case.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import 'package:gustosa/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvent, SignUpPageState> {
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final InsertAgentUseCase insertAgentUseCase;


  SignUpPageBloc(
      this.fetchUserUseCase,
      this.updateUserUseCase,
      this.insertAgentUseCase,
      ) : super(SignUpPageInitialState()) {
    on<SelectDateEvent>(selectDateEvent);
    on<UpdateDateEvent>(updateDateEvent);
    on<OnBackPressedEvent>(onBackPressedEvent);
    on<SignUpInitializeEvent>(signUpInitializeEvent);
    on<SignUpEvent>(signUpEvent);
  }
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailOrPhoneController = TextEditingController();
  DateTime? birthDatePicker;
  String? selectedGender;

  final auth = sl<AuthController>();
  final messaging = FirebaseMessaging.instance;

  FutureOr<void> selectDateEvent(
      SelectDateEvent event, Emitter<SignUpPageState> emit) {
    showDatePicker(
        context: event.context,
        builder: (BuildContext context, Widget? child) => Theme(
            data: ThemeData(
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // button text color
                  ),
                ),
                colorScheme: const ColorScheme.dark(
                    onSurface: Colors.white, primary: Colors.grey),
                datePickerTheme: const DatePickerThemeData(
                  headerBackgroundColor: Colors.black87,
                  backgroundColor: Colors.black87,
                  headerHeadlineStyle: TextStyle(color: Colors.white),
                  headerHelpStyle: TextStyle(color: Colors.white),
                  dayStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                  yearStyle: TextStyle(color: Colors.white),
                  surfaceTintColor: Colors.white,
                  dayForegroundColor:
                  MaterialStatePropertyAll(Colors.white),
                )),
            child: child!),
        initialDate: DateTime.now(),
        firstDate: DateTime(1850),
        lastDate: DateTime.now())
        .then((selectedDate) {
      if (selectedDate == null) return null;
      add(UpdateDateEvent(selectedDate));
    });
  }

  FutureOr<void> updateDateEvent(
      UpdateDateEvent event, Emitter<SignUpPageState> emit) {
    emit(DateUpdatingState());
    birthDatePicker = event.dateTime;
    dobController.text = DateFormat('yyyy-MM-dd').format(event.dateTime);
    emit(DateUpdatedState(event.dateTime));
  }

  FutureOr<void> onBackPressedEvent(
      OnBackPressedEvent event, Emitter<SignUpPageState> emit) async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushNamedAndRemoveUntil(
        event.context, AppRoutes.mainAuth, (route) => false);
  }

  FutureOr<void> signUpInitializeEvent(
      SignUpInitializeEvent event, Emitter<SignUpPageState> emit) {
    if (!sl<AuthBloc>().isPhoneLogin) {
      emit(BasicInfoUpdatingState());
      if (auth.currentUser!.userMetadata?['full_name'] != null) {
        if (auth.currentUser!.userMetadata?['full_name']!.split(" ").length >
            1) {
          firstNameController.text =
          auth.currentUser!.userMetadata?['full_name']!.split(" ")[0];
          lastNameController.text =
          auth.currentUser!.userMetadata?['full_name']!.split(" ")[1];
        } else {
          firstNameController.text =
          auth.currentUser!.userMetadata?['full_name']!;
        }
      }
      emit(BasicInfoUpdatedState());
    }
  }


  FutureOr<void> signUpEvent(
      SignUpEvent event, Emitter<SignUpPageState> emit) async {
    showToast(String message) {
      ToastManager(Toast(title: message, type: ToastificationType.error))
          .show(event.context);
    }

    emit(SigningUpState());

    final String firstName = firstNameController.text;
    final String email = emailOrPhoneController.text;
    if (firstName.isEmpty) {
      emit(SigningUpErrorState());
      showToast("Please enter your first name");
      return;
    }

    if (birthDatePicker == null) {
      emit(SigningUpErrorState());
      showToast("Please enter your date of birth");
      return;
    }

    final Duration ageDifference = DateTime.now().difference(birthDatePicker!);
    if (ageDifference.inDays <= 6590) {
      emit(SigningUpErrorState());
      showToast("You need to be at least 18 years old");
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
    final result = await fetchUserUseCase(email: email);
    result.fold((l) {}, (r) {
      if (r != null) {
        emit(SigningUpErrorState());
        showToast("Email already exists!");
        return;
      }
    });
    String? fcmToken = "";

    Future<void> onUserSignUp() async {
      final user = UserModel(
          gustId: Supabase.instance.client.auth.currentUser?.id,
          onboardStatus: OnboardStatus.signed_up,
          avatar: auth.currentUser?.userMetadata?['avatar_url'] ?? "",
          creationTime: "",
          gender: selectedGender,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          countryCode: sl<AuthBloc>().selectedCountry!.dialCode,
          phoneNumber: !sl<AuthBloc>().isPhoneLogin
              ? emailOrPhoneController.text
              .toLowerCase()
              : sl<AuthBloc>().phoneController.text,
          email: sl<AuthBloc>().isPhoneLogin
              ? emailOrPhoneController.text
              .toLowerCase()
              : sl<AuthBloc>().email,
          dob: DateFormat('yyyy-mm-dd').format(birthDatePicker!),
          role: sl<HomePageBloc>().entity);
      AppLocalStorage.updateUser(user);
      AppLocalStorage.updateGustId(user.gustId!);
      final result2 = await updateUserUseCase(user: user, uid: user.gustId!);
      result2.fold((l) {}, (r) async {
        if (sl<HomePageBloc>().entity == Entity.agent) {
          final reference = FirebaseStorage.instance.ref().child(
              'agent_profiles/${AppLocalStorage.gustId}.${sl<AgentSignUpPageBloc>().agentImageExt}');
          await reference.putData(sl<AgentSignUpPageBloc>().agentImage!);
          final uri = await reference.getDownloadURL();
          AgentModel agent = AgentModel(
              agentWorkEmail: user.email,
              agentImage: uri,
              gustId: user.gustId,
              agentName: user.name,
              agentLocation: sl<AgentSignUpPageBloc>().locationController.text,
              agentZipCode: sl<AgentSignUpPageBloc>().zipCodeController.text,
              agentApprovalStatus: AgentApprovalStatus.approved);
          await insertAgentUseCase(agent: agent).then((value) async {
            AppLocalStorage.updateUser(
                AppLocalStorage.user!.copyWith(role: Entity.agent));
            await updateUserUseCase(
                uid: AppLocalStorage.gustId!, user: AppLocalStorage.user!);
            AppLocalStorage.updateAgent(agent);
            clearAndReinitializeDependencies().then((value) {
              Navigator.pushNamedAndRemoveUntil(
                  event.context, AppRoutes.splash, (route) => false);
            });
          });
        }
        AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.loggedIn);
      });
    }

    onUserSignUp();
  }

}