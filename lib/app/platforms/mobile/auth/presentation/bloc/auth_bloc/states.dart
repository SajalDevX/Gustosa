part of 'bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class InitializingState extends AuthState {
  final bool isInitialState;

  const InitializingState(this.isInitialState);
}

class InitializedState extends AuthState {}

class PhoneVerificationInitiatedState extends AuthState {}
class PhoneVerificationFailedState extends AuthState {}

class OtpSendForVerificationState extends AuthState {}

class AuthenticatingWithGoogleState extends AuthState {}

class AuthenticationCompleteWithGoogleState extends AuthState {}

class AuthenticatingWithAppleState extends AuthState {}

class AuthenticationCompleteWithAppleState extends AuthState {}

class PhoneUpdatingState extends AuthState {}

class PhoneUpdatedState extends AuthState {}

class CountryUpdatingState extends AuthState {}

class CountryUpdatedState extends AuthState {}

class PhoneVerifyingState extends AuthState {}

class PhoneVerifiedState extends AuthState {}

class ResendingOtpState extends AuthState {}

class EmailVerifyingState extends AuthState {}
