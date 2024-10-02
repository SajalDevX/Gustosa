part of 'bloc.dart';


abstract class SignUpPageEvent extends Equatable {
  const SignUpPageEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends SignUpPageEvent {
  final BuildContext context;

  const SignUpEvent(this.context);
}

class OnBackPressedEvent extends SignUpPageEvent {
  final BuildContext context;

  const OnBackPressedEvent(this.context);
}
