import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_keys.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:gustosa/app/shared/config/constants/enums.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserModel {
  @HiveField(1)
  @JsonKey(name: UserKeys.avatarKey)
  final String? avatar;

  @HiveField(2)
  @JsonKey(name: UserKeys.creationTimeKey)
  final String? creationTime;

  @HiveField(3)
  @JsonKey(name: UserKeys.dobKey)
  final String? dob;

  @HiveField(4)
  @JsonKey(name: UserKeys.emailKey)
  final String? email;

  @HiveField(5)
  @JsonKey(name: UserKeys.genderKey)
  final String? gender;

  @HiveField(6)
  @JsonKey(name: UserKeys.roleKey)
  final Entity? role;

  @HiveField(7)
  @JsonKey(name: UserKeys.gustIdKey)
  final String? gustId;

  @HiveField(8)
  @JsonKey(name: UserKeys.conversationsKey)
  List<String>? conversations;

  @HiveField(9)
  @JsonKey(name: 'onboard_status')
  OnboardStatus onboardStatus;

  @HiveField(10)
  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  @HiveField(11)
  @JsonKey(name: 'country_code')
  String? countryCode;

  @HiveField(12)
  @JsonKey(name: 'first_name')
  String? firstName;

  @HiveField(13)
  @JsonKey(name: 'last_name')
  String? lastName;

  UserModel(
      {this.avatar,
      this.creationTime,
      this.dob,
      this.email,
      this.gender,
      this.role,
      this.gustId,
      this.conversations,
      this.phoneNumber,
      this.countryCode,
      this.firstName,
      this.lastName,
      required this.onboardStatus});

  String get name => "${firstName ?? ""} ${lastName ?? ""}".toUpperCase();

  String get phoneNumberWithCountryCode =>
      "+${countryCode?.replaceAll('+', '') ?? ""}${phoneNumber ?? ""}";

  String get phoneNumberWithoutCountryCode =>
      (phoneNumber ?? "").replaceFirst(countryCode!, "");

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? avatar,
    String? creationTime,
    String? dob,
    String? email,
    String? gender,
    Entity? role,
    String? gustId,
    List<String>? conversations,
    OnboardStatus? onboardStatus,
    String? phoneNumber,
    String? countryCode,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      onboardStatus: onboardStatus ?? this.onboardStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      creationTime: creationTime ?? this.creationTime,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      gustId: gustId ?? this.gustId,
      conversations: conversations ?? List.from(this.conversations ?? []),
    );
  }

  UserModel copyWithFromJson(Map<String, dynamic>? json) {
    if (json == null) return this;

    return copyWith(
      gustId: json[UserKeys.gustIdKey] ?? gustId,
      avatar: json[UserKeys.avatarKey] ?? avatar,
      creationTime: json[UserKeys.creationTimeKey] ?? creationTime,
      dob: json[UserKeys.dobKey] ?? dob,
      email: json[UserKeys.emailKey] ?? email,
      gender: json[UserKeys.genderKey] ?? gender,
      role: json[UserKeys.roleKey] ?? role,
      conversations: json[UserKeys.conversationsKey] != null
          ? List<String>.from(json[UserKeys.conversationsKey])
          : conversations,
    );
  }
}
