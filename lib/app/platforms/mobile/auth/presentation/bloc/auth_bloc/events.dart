part of 'bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateWithPhoneEvent extends AuthEvent {
  final BuildContext context;

  const AuthenticateWithPhoneEvent(this.context);
}

class AuthenticateWithGoogleEvent extends AuthEvent {
  final BuildContext context;

  const AuthenticateWithGoogleEvent(this.context);
}

class AuthenticateWithAppleEvent extends AuthEvent {
  final BuildContext context;

  const AuthenticateWithAppleEvent(this.context);
}

class InitializeEvent extends AuthEvent {
  final bool isInitState;

  const InitializeEvent(this.isInitState);
}

class DisposeEvent extends AuthEvent {}

class OnBackClickedEvent extends AuthEvent {
  final BuildContext context;

  const OnBackClickedEvent(this.context);
}

class OnPhoneUpdateEvent extends AuthEvent {}

class OnCountryUpdateEvent extends AuthEvent {
  final BuildContext context;

  const OnCountryUpdateEvent(this.context);
}

class OnVerifyEvent extends AuthEvent {
  final String value;
  final Function()? onVerify;
  final BuildContext context;

  const OnVerifyEvent(this.value, this.context, {this.onVerify});
}

class OnOtpResendEvent extends AuthEvent {
  final BuildContext context;

  const OnOtpResendEvent(this.context);
}

class AuthPageCodeSentEvent extends AuthEvent {
  final BuildContext context;

  const AuthPageCodeSentEvent(this.context);
}

class ConvertToAgentEvent extends AuthEvent {
  final String email;
  final BuildContext context;

  const ConvertToAgentEvent(this.email, this.context);
}

class PhoneVerificationFailedEvent extends AuthEvent {
  const PhoneVerificationFailedEvent();
}

class CountDownForResendFunction extends AuthEvent {
  const CountDownForResendFunction();
}