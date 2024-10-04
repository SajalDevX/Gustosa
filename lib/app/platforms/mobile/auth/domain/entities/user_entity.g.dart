// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 1;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      gustId: fields[1] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      email: fields[5] as String?,
      phoneNumber: fields[4] as String?,
      avatar: fields[6] as String?,
      onboardStatus: fields[7] as OnboardStatus,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.gustId)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.avatar)
      ..writeByte(7)
      ..write(obj.onboardStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      gustId: json['gust_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email_id'] as String?,
      phoneNumber: json['phone_number'] as String?,
      avatar: json['avatar'] as String?,
      onboardStatus:
          $enumDecode(_$OnboardStatusEnumMap, json['onboard_status']),
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'gust_id': instance.gustId ,
      'first_name': instance.firstName ?? '',
      'last_name': instance.lastName??'',
      'phone_number': instance.phoneNumber??'',
      'email_id': instance.email,
      'avatar': instance.avatar??"",
      'onboard_status': _$OnboardStatusEnumMap[instance.onboardStatus]??'',
    };

const _$OnboardStatusEnumMap = {
  OnboardStatus.authenticated: 'authenticated',
  OnboardStatus.signed_up: 'signed_up',
};
