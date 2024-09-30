part of 'bloc.dart';

abstract class SignUpPageEvent extends Equatable {
  const SignUpPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class SelectDateEvent extends SignUpPageEvent {
  final BuildContext context;

  const SelectDateEvent(this.context);
}

class UpdateDateEvent extends SignUpPageEvent {
  final DateTime dateTime;

  const UpdateDateEvent(this.dateTime);
}

class SignUpEvent extends SignUpPageEvent {
  final BuildContext context;

  const SignUpEvent(this.context);
}

class OnBackPressedEvent extends SignUpPageEvent {
  final BuildContext context;

  const OnBackPressedEvent(this.context);
}

class SignUpInitializeEvent extends SignUpPageEvent {}


