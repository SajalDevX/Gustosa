import 'package:hive_flutter/adapters.dart';

part 'enums.g.dart';
enum NetworkException { noInternetConnection, timeOutError, unknown }

enum HttpException { unAuthorized, internalServerError, unknown }

@HiveType(typeId: 2)
enum OnboardStatus {
  @HiveField(0)
  authenticated,
  @HiveField(1)
  signed_up
}

@HiveType(typeId: 0)
enum UserOnboardStatus {
  @HiveField(0)
  initial,
  @HiveField(1)
  onboardDone,
  @HiveField(2)
  signUpForm,
  @HiveField(3)
  loggedIn,
}
@HiveType(typeId: 3)
enum AgentApprovalStatus {
  @HiveField(0)
  approved,
  @HiveField(1)
  pending,
  @HiveField(2)
  denied
}
@HiveType(typeId: 4)
enum Entity {
  @HiveField(0)
  user,
  @HiveField(1)
  agent,
  @HiveField(2)
  admin
}