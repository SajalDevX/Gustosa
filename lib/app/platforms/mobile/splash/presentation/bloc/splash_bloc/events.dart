part of 'bloc.dart';

abstract class SplashPageEvent extends Equatable {
  const SplashPageEvent();

  @override
  List<Object> get props => [];
}

class InitializeEvent extends SplashPageEvent {}

class DisposeEvent extends SplashPageEvent {}

class OnVideoEndEvent extends SplashPageEvent {
  final double visibility;

  OnVideoEndEvent(this.visibility);
}
