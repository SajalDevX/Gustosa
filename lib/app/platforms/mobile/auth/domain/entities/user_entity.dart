import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../shared/config/constants/enums.dart';

part 'user_entity.g.dart';

part 'user_keys.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserEntity {
  @HiveField(1)
  @JsonKey(name: UserKeys.gustIdKey)
  final String? gustId;

  @HiveField(2)
  @JsonKey(name: UserKeys.firstNameKey)
  String? firstName;

  @HiveField(3)
  @JsonKey(name: UserKeys.lastNameKey)
  String? lastName;

  @HiveField(4)
  @JsonKey(name: UserKeys.phoneNumberKey)
  String? phoneNumber;

  @HiveField(5)
  @JsonKey(name: UserKeys.emailKey)
  String? email;

  @HiveField(6)
  @JsonKey(name: UserKeys.avatarKey)
  String? avatar;

  @HiveField(7)
  @JsonKey(name: UserKeys.onBoardStatusKey)
  OnboardStatus onboardStatus;

  UserEntity(
      {required this.gustId,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.avatar,
      required this.onboardStatus});

  String get name => "${firstName ?? ""} ${lastName ?? ""}".toUpperCase();


  String get phoneNumberWithoutCountryCode =>
      (phoneNumber ?? "");

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  UserEntity copyWith(
      String? gustId,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? avatar,
      OnboardStatus? onboardStatus) {
    return UserEntity(
      gustId: gustId ?? this.gustId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      onboardStatus: onboardStatus ?? this.onboardStatus,
    );
  }
}
