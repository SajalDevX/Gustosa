// auth_event.dart
part of 'bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Existing Events
class AuthCheckRequested extends AuthEvent {}

class AuthSignInWithGoogleRequested extends AuthEvent {
  final BuildContext context;

  const AuthSignInWithGoogleRequested(this.context);

  @override
  List<Object> get props => [context];
}

class AuthSignInWithPhoneRequested extends AuthEvent {
  final String phoneNumber;
  final BuildContext context;

  const AuthSignInWithPhoneRequested(this.phoneNumber, this.context);

  @override
  List<Object> get props => [phoneNumber, context];
}

class AuthVerifyPhoneRequested extends AuthEvent {
  final String verificationId;
  final String otp;
  final BuildContext context;

  const AuthVerifyPhoneRequested(this.verificationId, this.otp, this.context);

  @override
  List<Object> get props => [verificationId, otp, context];
}

class AuthResendOtpRequested extends AuthEvent {
  final String phoneNumber;
  final BuildContext context;

  const AuthResendOtpRequested(this.phoneNumber, this.context);

  @override
  List<Object> get props => [phoneNumber, context];
}

class AuthStartResendOtpCountdown extends AuthEvent {}
