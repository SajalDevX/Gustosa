part of 'bloc.dart';

abstract class AgentSignUpPageEvent extends Equatable {
  const AgentSignUpPageEvent();

  @override
  List<Object> get props => [];
}

class InitializeEvent extends AgentSignUpPageEvent {}

class FetchCategoriesEvent extends AgentSignUpPageEvent {}

class CaptureImageEvent extends AgentSignUpPageEvent {}

class UpdateAgentEvent extends AgentSignUpPageEvent {
  final BuildContext context;

  const UpdateAgentEvent(this.context);
}