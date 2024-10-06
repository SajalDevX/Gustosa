import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/insert_user_use_case.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../../../../../../shared/config/constants/enums.dart';
import '../../../../../../shared/config/routes/routes.dart';
import '../../../../../../shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import '../../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../../../../../shared/core/local_storage/local_storage.dart';
import '../../../data/models/countriesModel.dart';
import '../../../domain/usecases/fetch_user_use_case.dart';
import '../../../domain/usecases/update_user_use_case.dart';

part 'events.dart';

part 'states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final InsertUserUseCase insertUserUseCase;
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AuthBloc(
    this.fetchUserUseCase,
    this.updateUserUseCase,
    this.insertUserUseCase,
  ) : super(AuthInitial()) {
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogle);
    on<AuthSignInWithPhoneRequested>(_onSignInWithPhoneRequested);
    on<AuthVerifyPhoneRequested>(_onVerifyPhoneRequested);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
    on<AuthStartResendOtpCountdown>(_onStartResendOtpCountdown);
  }

  final auth = sl<AuthController>();
  bool exitApp = false;
  late List<Country> _countryList;
  late List<Country> filteredCountries;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode focusNode = FocusNode();
  var phoneNumberWithoutCountryCode = "";
  Country? selectedCountry= Country(
    name: "India",
    flag: "🇮🇳",
    code: "IN",
    dialCode: "91",
    minLength: 10,
    maxLength: 10,
  );
  late TextInputFormatter formatter;
  String? email;
  int resendSeconds = 60;
  CountdownController countdown = CountdownController(autoStart: false);
  int countDownForResendStartValue = 60;
  late Timer countDownForResend;
  bool resendValidation = false;
  String? firebaseVerificationId;

  Timer? _countdownTimer;
  static const int _countdownDuration = 60;

  void setVerificationId(String id) {
    firebaseVerificationId = id;
  }

  String get phoneNumber =>
      "+${selectedCountry!.dialCode}${phoneController.text}"
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '');

  bool get isPhoneLogin {
    return auth.firebaseCurrentUser?.email?.trim().isEmpty ?? true;
  }

  Future<void> _onSignInWithGoogle(
      AuthSignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final googleAuth = await auth.signInWithGoogle();
      email = googleAuth.email;
      await insertUserUseCase(user: UserEntity(gustId: googleAuth.uid, onboardStatus: OnboardStatus.authenticated,email: googleAuth.email));
      print("Email is : ${googleAuth.email}");
      final result = await fetchUserUseCase(email: googleAuth.email);
      result.fold((l) {}, (user) {
        if (user != null) {
          _navigateToSignUp(event.context, user: user);
        }
      });
    } catch (e) {
      emit(AuthError(e.toString()));
    }
    emit(AuthenticationCompleteWithGoogleState());
  }

  Future<void> _onSignInWithPhoneRequested(
      AuthSignInWithPhoneRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await auth.signInWithPhoneFirebase(event.phoneNumber, event.context);
      emit(AuthOtpSent(phoneNumber));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyPhoneRequested(
      AuthVerifyPhoneRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final phoneAuth = await auth.verifyPhoneFirebase(firebaseVerificationId!, event.otp);
      await insertUserUseCase(user: UserEntity(gustId: phoneAuth!.uid, onboardStatus: OnboardStatus.authenticated,phoneNumber: phoneAuth.phoneNumber));
      final result = await fetchUserUseCase(phoneNumber: phoneAuth.phoneNumber);
      result.fold((l) {}, (user) {
        if (user != null) {
          _navigateToSignUp(event.context, user: user);
        }
      });
    } catch (e) {
      emit(AuthError(e.toString()));
    }
    emit(AuthPhoneVerified());
  }

  Future<void> _onResendOtpRequested(
      AuthResendOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await auth.resendOtpFirebase(event.phoneNumber, event.context);
      emit(AuthOtpResent(event.phoneNumber));
      add(AuthStartResendOtpCountdown());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onStartResendOtpCountdown(
      AuthStartResendOtpCountdown event, Emitter<AuthState> emit) async {
    int seconds = _countdownDuration;
    emit(AuthResendOtpCountdown(seconds));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds > 0) {
        emit(AuthResendOtpCountdown(seconds));
      } else {
        timer.cancel();
        emit(AuthResendOtpEnable());
      }
    });
  }

  Future<void> _navigateToSignUp(context, {required UserEntity user}) async {
    final isNewUser = user.onboardStatus == OnboardStatus.authenticated;

    if (isNewUser) {
      AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.signUpForm);
      Navigator.pushNamed(context, AppRoutes.userSignUp);
      return;
    }
    AppLocalStorage.updateGustId(user.gustId!);
    final result = await fetchUserUseCase(uid: user.gustId);
    result.fold(
      (l) => null,
      (user) async {
        if (user != null) {
          AppLocalStorage.updateUserOnboardingStatus(
              UserOnboardStatus.loggedIn);
          AppLocalStorage.updateUser(user);

            Navigator.pushReplacementNamed(context, AppRoutes.home);

        } else {
          AppLocalStorage.updateUserOnboardingStatus(
              UserOnboardStatus.signUpForm);
          Navigator.pushNamed(context, AppRoutes.userSignUp);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
