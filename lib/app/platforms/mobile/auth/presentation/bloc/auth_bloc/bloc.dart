import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../shared/config/constants/constants.dart';
import '../../../../../../shared/config/constants/country_masks.dart';
import '../../../../../../shared/config/constants/enums.dart';
import '../../../../../../shared/config/routes/routes.dart';
import '../../../../../../shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import '../../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../../../../../shared/core/utils/toast_manager.dart';
import '../../../data/models/countriesModel.dart';
import '../../../domain/entities/agent_model.dart';
import '../../../domain/entities/user_model.dart';
import '../../../domain/usecases/fetch_agents_use_case.dart';
import '../../../domain/usecases/fetch_user_use_case.dart';
import '../../../domain/usecases/insert_agent_use_case.dart';
import '../../../domain/usecases/update_user_use_case.dart';

part 'events.dart';

part 'states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final InsertAgentUseCase insertAgentUseCase;
  final FetchAgentsUseCase fetchAgentUseCase;

  AuthBloc(
    this.fetchUserUseCase,
    this.updateUserUseCase,
    this.insertAgentUseCase,
    this.fetchAgentUseCase,
  ) : super(AuthInitialState()) {
    on<AuthenticateWithPhoneEvent>(authenticateWithPhoneEvent);
    on<AuthenticateWithGoogleEvent>(authenticateWithGoogleEvent);
    on<AuthenticateWithAppleEvent>(authenticateWithAppleEvent);
    on<InitializeEvent>(initializeEvent);
    on<DisposeEvent>(disposeEvent);
    on<OnBackClickedEvent>(onBackClickedEvent);
    on<OnPhoneUpdateEvent>(onPhoneUpdateEvent);
    on<OnCountryUpdateEvent>(onCountryUpdateEvent);
    on<OnVerifyEvent>(onVerifyEvent);
    on<OnOtpResendEvent>(onOtpResendEvent);
    on<AuthPageCodeSentEvent>(authPageCodeSentEvent);
    on<PhoneVerificationFailedEvent>(phoneVerificationFailedEvent);
    on<CountDownForResendFunction>(countDownForResendFunction);
    on<ConvertToAgentEvent>(convertToAgentEvent);
  }

  final auth = sl<AuthController>();
  bool exitApp = false;
  late List<Country> _countryList;
  late List<Country> filteredCountries;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode focusNode = FocusNode();
  var phoneNumberWithoutCountryCode = "";
  Country? selectedCountry;
  late TextInputFormatter formatter;
  String? email;
  int resendSeconds = 60;
  CountdownController countdown = CountdownController();
  int countDownForResendStartValue = 60;
  late Timer countDownForResend;
  bool resendValidation = false;
  String? firebaseVerificationId;

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
    return auth.currentUser?.email?.trim().isEmpty ?? true;
  }

  bool get isUser => sl<HomePageBloc>().entity == Entity.user;

  Future<void> _navigateToSignUp(context, {required UserModel user}) async {
    bool isNewUser = user.onboardStatus == OnboardStatus.authenticated;
    if (isNewUser) {
      AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.signUpForm);
      Navigator.pushNamed(context, AppRoutes.newTutorial);
      return;
    }
    AppLocalStorage.updateGustId(user.gustId!);
    final result = await fetchUserUseCase(uid: user.gustId!);
    result.fold((l) => null, (user) async {
      if (user != null) {
        final result = await fetchAgentUseCase(uid: user.gustId);
        result.fold((l) => null, (r) {
          AppLocalStorage.updateUserOnboardingStatus(
              UserOnboardStatus.loggedIn);
          AppLocalStorage.updateUser(user);
          if (r.isNotEmpty) {
            if (isUser) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              return;
            }
            AppLocalStorage.updateAgent(r.first);
            switch (AppLocalStorage.agent!.agentApprovalStatus!) {
              case AgentApprovalStatus.approved:
                Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
                    arguments: AgentHomePageArgs(tabValue: 1));
                break;
              case AgentApprovalStatus.pending:
              case AgentApprovalStatus.denied:
                Navigator.pushReplacementNamed(context, AppRoutes.agentStatus,
                    arguments: AppLocalStorage.agent!.agentApprovalStatus!);
                break;
            }
          } else {
            if (isUser) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else {
              AppLocalStorage.updateUserOnboardingStatus(
                  UserOnboardStatus.signUpForm);
              Navigator.pushNamed(context, AppRoutes.newTutorial);
              return;
            }
          }
        });
      } else {
        AppLocalStorage.updateUserOnboardingStatus(
            UserOnboardStatus.signUpForm);
        Navigator.pushNamed(context, AppRoutes.newTutorial);
      }
    });
  }

  Future<void> authenticateWithPhoneEvent(
      AuthenticateWithPhoneEvent event, Emitter<AuthState> emit) async {
    emit(PhoneVerificationInitiatedState());
    if(phoneController.text.isNotEmpty){
      auth.signInWithPhone(phoneNumber).then((value){
        add(AuthPageCodeSentEvent(event.context));
      });
    }else{
      emit(PhoneVerificationFailedState());
      ToastManager(
        Toast(
          title: Constants.enterNumber,
          type: ToastificationType.warning,
        ),
      ).show(event.context);
    }
  }

  FutureOr<void> authenticateWithGoogleEvent(
      AuthenticateWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthenticatingWithGoogleState());
    try {
      AuthResponse googleAuth = await auth.signInWithGoogle();
      if (googleAuth.user != null) {
        email = googleAuth.user!.email;
        final result = await fetchUserUseCase(email: googleAuth.user!.email);
        result.fold((l) {}, (user) {
          if (user != null) {
            _navigateToSignUp(event.context, user: user);
          }
        });
      }
    } catch (error) {
      if (kDebugMode) {
      }
    }

    emit(AuthenticationCompleteWithGoogleState());
  }

  FutureOr<void> authenticateWithAppleEvent(
      AuthenticateWithAppleEvent event, Emitter<AuthState> emit) async {
    emit(AuthenticatingWithAppleState());
    try {
      AuthResponse appleAuth = await auth.signInWithApple();
      if (appleAuth.user != null) {
        email = appleAuth.user!.email;
        final result = await fetchUserUseCase(email: appleAuth.user!.email);
        result.fold((l) {}, (user) {
          if (user != null) {
            _navigateToSignUp(event.context, user: user);
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during Apple Sign-In: $e");
      }
    }
    emit(AuthenticationCompleteWithAppleState());
  }

  FutureOr<void> initializeEvent(
      InitializeEvent event, Emitter<AuthState> emit) async {
    emit(InitializingState(event.isInitState));
    await resetSignUpPageBlocInstance();
    _countryList = countries;
    await sl<HomePageBloc>().updateLocation();
    selectedCountry = sl<HomePageBloc>().country;
    formatter = MaskTextInputFormatter(
      mask: countryMasks[selectedCountry!.code],
      filter: {"#": RegExp(r'[0-9]')},
    );
    _countryList = countries;
    filteredCountries = _countryList;
    emit(InitializedState());
  }

  FutureOr<void> disposeEvent(
      DisposeEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> onBackClickedEvent(
      OnBackClickedEvent event, Emitter<AuthState> emit) async {
    exitApp = !exitApp;
    if (exitApp) {
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: const Text(
          Constants.exitText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        margin: const EdgeInsets.all(120),
      ));
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  FutureOr<void> onPhoneUpdateEvent(
      OnPhoneUpdateEvent event, Emitter<AuthState> emit) async {
    emit(PhoneUpdatingState());
    final initialPhoneNumber = PhoneNumber(
      countryISOCode: selectedCountry!.code,
      countryCode: '+${selectedCountry!.dialCode}',
      number: phoneController.text
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', ''),
    );
    int phoneLengthBasedOnCountryCode = countries
        .firstWhere(
            (element) => element.code == initialPhoneNumber.countryISOCode)
        .maxLength;

    if (initialPhoneNumber.number.length == phoneLengthBasedOnCountryCode) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    phoneNumberWithoutCountryCode = phoneController.text;
    emit(PhoneUpdatedState());
  }

  FutureOr<void> onCountryUpdateEvent(
      OnCountryUpdateEvent event, Emitter<AuthState> emit) async {
    emit(CountryUpdatingState());
    bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;

    filteredCountries = _countryList;
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      isScrollControlled: true,
      context: event.context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (ctx, setStateCountry) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7f7f97), width: 0.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                child: TextField(
                  onChanged: (value) {
                    filteredCountries = isNumeric(value)
                        ? _countryList
                        .where(
                            (country) => country.dialCode.contains(value))
                        .toList()
                        : _countryList
                        .where((country) => country.name
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                        .toList();
                    setStateCountry(() {});
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: 'Search country',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/search_new.svg',
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredCountries.length,
                  itemBuilder: (ctx, index) => Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          selectedCountry = filteredCountries[index];
                          formatter = MaskTextInputFormatter(
                            mask: countryMasks[selectedCountry!.code],
                            filter: {"#": RegExp(r'[0-9]')},
                          );
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/flags/${filteredCountries[index].code.toLowerCase()}.png',
                            width: 50,
                          ),
                        ),
                        title: Text(
                          filteredCountries[index].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        trailing: Text(
                          '+${filteredCountries[index].dialCode}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      const Divider(thickness: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    emit(CountryUpdatedState());
  }

  FutureOr<void> onVerifyEvent(
      OnVerifyEvent event, Emitter<AuthState> emit) async {
    if (event.value.length == Constants.otpLength &&
        state is! PhoneVerifyingState) {
      emit(PhoneVerifyingState());
      try {
        AuthResponse phoneAuth =
        await auth.verifyPhone(event.value, phoneNumber, event.onVerify != null);

        if (phoneAuth.user != null) {

          if (event.onVerify == null) {
            final result =
            await fetchUserUseCase(phoneNumber: phoneNumber.substring(1));
            result.fold((l) {}, (user) {
              if (user != null) {
                _navigateToSignUp(event.context, user: user);
              }
            });
          } else {
            event.onVerify?.call();
          }
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    }
  }

  FutureOr<void> onOtpResendEvent(
      OnOtpResendEvent event, Emitter<AuthState> emit) async {
    countdown.start();
    emit(ResendingOtpState());
    // auth.resendOtp(phoneNumber).then((value) { // supabase
    auth.resendOtpFirebase(phoneNumber, event.context).then((value) {
      // firebase
      add(CountDownForResendFunction());
    });
  }

  FutureOr<void> authPageCodeSentEvent(
      AuthPageCodeSentEvent event, Emitter<AuthState> emit) {
    emit(AuthInitialState());
    Navigator.pushNamed(event.context, AppRoutes.otpVerification);
  }

  FutureOr<void> phoneVerificationFailedEvent(
      PhoneVerificationFailedEvent event, Emitter<AuthState> emit) {
    emit(PhoneVerificationFailedState());
  }

  FutureOr<void> countDownForResendFunction(
      CountDownForResendFunction event, Emitter<AuthState> emit) {
    const oneSec = Duration(seconds: 1);
    countDownForResend = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (countDownForResendStartValue == 0) {
          timer.cancel();
          resendValidation = true;
          countDownForResendStartValue = 60;
        } else {
          countDownForResendStartValue--;
        }
      },
    );
  }


  FutureOr<void> convertToAgentEvent(
      ConvertToAgentEvent event, Emitter<AuthState> emit) async {
    emit(EmailVerifyingState());
    final reference = FirebaseStorage.instance.ref().child(
        'agent_profiles/${AppLocalStorage.gustId}.${sl<AgentSignUpPageBloc>().agentImageExt}');
    await reference.putData(sl<AgentSignUpPageBloc>().agentImage!);
    final uri = await reference.getDownloadURL();
    AgentModel agent = AgentModel(
        agentWorkEmail: event.email,
        agentImage: uri,
        gustId: AppLocalStorage.gustId,
        agentName: sl<AgentSignUpPageBloc>().nameController.text,
        agentBrand: sl<AgentSignUpPageBloc>().selectedBrand?.toJson(),
        agentLocation: sl<AgentSignUpPageBloc>().locationController.text,
        agentZipCode: sl<AgentSignUpPageBloc>().zipCodeController.text,
        agentDomain: sl<AgentSignUpPageBloc>().selectedBrandDomain ??
            event.email.split('@')[1],
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
}
