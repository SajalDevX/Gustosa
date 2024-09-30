// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      avatar: fields[1] as String?,
      creationTime: fields[2] as String?,
      dob: fields[3] as String?,
      email: fields[4] as String?,
      gender: fields[5] as String?,
      role: fields[6] as Entity?,
      gustId: fields[7] as String?,
      conversations: (fields[8] as List?)?.cast<String>(),
      phoneNumber: fields[10] as String?,
      countryCode: fields[11] as String?,
      firstName: fields[12] as String?,
      lastName: fields[13] as String?,
      onboardStatus: fields[9] as OnboardStatus,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.creationTime)
      ..writeByte(3)
      ..write(obj.dob)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.gustId)
      ..writeByte(8)
      ..write(obj.conversations)
      ..writeByte(9)
      ..write(obj.onboardStatus)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.countryCode)
      ..writeByte(12)
      ..write(obj.firstName)
      ..writeByte(13)
      ..write(obj.lastName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      avatar: json['avatar'] as String?,
      creationTime: json['creationtime'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      role: $enumDecodeNullable(_$EntityEnumMap, json['role']),
      gustId: json['gust_id'] as String?,
      conversations: (json['conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      phoneNumber: json['phone_number'] as String?,
      countryCode: json['country_code'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      onboardStatus:
          $enumDecode(_$OnboardStatusEnumMap, json['onboard_status']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'creationtime': instance.creationTime,
      'dob': instance.dob,
      'email': instance.email,
      'gender': instance.gender,
      'role': _$EntityEnumMap[instance.role],
      'gust_id': instance.gustId,
      'conversations': instance.conversations,
      'onboard_status': _$OnboardStatusEnumMap[instance.onboardStatus]!,
      'phone_number': instance.phoneNumber,
      'country_code': instance.countryCode,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

const _$EntityEnumMap = {
  Entity.user: 'user',
  Entity.agent: 'agent',
  Entity.admin: 'admin',
};

const _$OnboardStatusEnumMap = {
  OnboardStatus.authenticated: 'authenticated',
  OnboardStatus.signed_up: 'signed_up',
};
