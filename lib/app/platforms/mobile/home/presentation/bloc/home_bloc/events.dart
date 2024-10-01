part of 'bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class UpdateHomeScreenIndexEvent extends HomePageEvent {
  final int index;
  final BuildContext context;

  const UpdateHomeScreenIndexEvent(this.index, this.context);
}
class UpdateUserRoleEvent extends HomePageEvent {
  final Entity entity;
  final BuildContext context;

  const UpdateUserRoleEvent(this.entity, this.context);
}
class ConnectChromeExtension extends HomePageEvent {
  final BuildContext context;
  final String? data;

  ConnectChromeExtension(this.data, this.context);
}

class UpdateUserProfileEvent extends HomePageEvent {}