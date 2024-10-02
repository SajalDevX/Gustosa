// auth_state.dart
part of 'bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Existing States
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthenticationCompleteWithGoogleState extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Existing OTP States
class AuthOtpSent extends AuthState {
  final String phoneNumber;

  const AuthOtpSent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthPhoneVerified extends AuthState {}

class AuthOtpResent extends AuthState {
  final String phoneNumber;

  const AuthOtpResent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

// **New States for Countdown**
class AuthResendOtpCountdown extends AuthState {
  final int secondsRemaining;

  const AuthResendOtpCountdown(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}

class AuthResendOtpEnable extends AuthState {}
