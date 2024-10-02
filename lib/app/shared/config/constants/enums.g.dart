// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardStatusAdapter extends TypeAdapter<OnboardStatus> {
  @override
  final int typeId = 2;

  @override
  OnboardStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OnboardStatus.authenticated;
      case 1:
        return OnboardStatus.signed_up;
      default:
        return OnboardStatus.authenticated;
    }
  }

  @override
  void write(BinaryWriter writer, OnboardStatus obj) {
    switch (obj) {
      case OnboardStatus.authenticated:
        writer.writeByte(0);
        break;
      case OnboardStatus.signed_up:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserOnboardStatusAdapter extends TypeAdapter<UserOnboardStatus> {
  @override
  final int typeId = 0;

  @override
  UserOnboardStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserOnboardStatus.initial;
      case 1:
        return UserOnboardStatus.onboardDone;
      case 2:
        return UserOnboardStatus.signUpForm;
      case 3:
        return UserOnboardStatus.loggedIn;
      default:
        return UserOnboardStatus.initial;
    }
  }

  @override
  void write(BinaryWriter writer, UserOnboardStatus obj) {
    switch (obj) {
      case UserOnboardStatus.initial:
        writer.writeByte(0);
        break;
      case UserOnboardStatus.onboardDone:
        writer.writeByte(1);
        break;
      case UserOnboardStatus.signUpForm:
        writer.writeByte(2);
        break;
      case UserOnboardStatus.loggedIn:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOnboardStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentApprovalStatusAdapter extends TypeAdapter<AgentApprovalStatus> {
  @override
  final int typeId = 3;

  @override
  AgentApprovalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AgentApprovalStatus.approved;
      case 1:
        return AgentApprovalStatus.pending;
      case 2:
        return AgentApprovalStatus.denied;
      default:
        return AgentApprovalStatus.approved;
    }
  }

  @override
  void write(BinaryWriter writer, AgentApprovalStatus obj) {
    switch (obj) {
      case AgentApprovalStatus.approved:
        writer.writeByte(0);
        break;
      case AgentApprovalStatus.pending:
        writer.writeByte(1);
        break;
      case AgentApprovalStatus.denied:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentApprovalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntityAdapter extends TypeAdapter<Entity> {
  @override
  final int typeId = 4;

  @override
  Entity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Entity.user;
      case 1:
        return Entity.agent;
      case 2:
        return Entity.admin;
      default:
        return Entity.user;
    }
  }

  @override
  void write(BinaryWriter writer, Entity obj) {
    switch (obj) {
      case Entity.user:
        writer.writeByte(0);
        break;
      case Entity.agent:
        writer.writeByte(1);
        break;
      case Entity.admin:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
