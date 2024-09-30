// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentModelAdapter extends TypeAdapter<AgentModel> {
  @override
  final int typeId = 6;

  @override
  AgentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentModel(
      agentWorkEmail: fields[1] as String?,
      agentApprovalStatus: fields[2] as AgentApprovalStatus?,
      agentDomain: fields[3] as String?,
      agentName: fields[5] as String?,
      agentBrand: (fields[6] as Map?)?.cast<String, dynamic>(),
      agentLocation: fields[7] as String?,
      agentZipCode: fields[8] as String?,
      agentImage: fields[9] as String?,
      gustId: fields[10] as String?,
      agentConversations: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AgentModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.agentWorkEmail)
      ..writeByte(2)
      ..write(obj.agentApprovalStatus)
      ..writeByte(3)
      ..write(obj.agentDomain)
      ..writeByte(4)
      ..write(obj.agentConversations)
      ..writeByte(5)
      ..write(obj.agentName)
      ..writeByte(6)
      ..write(obj.agentBrand)
      ..writeByte(7)
      ..write(obj.agentLocation)
      ..writeByte(8)
      ..write(obj.agentZipCode)
      ..writeByte(9)
      ..write(obj.agentImage)
      ..writeByte(10)
      ..write(obj.gustId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModel _$AgentModelFromJson(Map<String, dynamic> json) => AgentModel(
      agentWorkEmail: json['agent_work_email'] as String?,
      agentApprovalStatus: $enumDecodeNullable(
          _$AgentApprovalStatusEnumMap, json['agent_approval_status']),
      agentDomain: json['agent_domain'] as String?,
      agentName: json['agent_name'] as String?,
      agentBrand: json['agent_brand'] as Map<String, dynamic>?,
      agentLocation: json['agent_location'] as String?,
      agentZipCode: json['agent_zipcode'] as String?,
      agentImage: json['agent_image'] as String?,
      gustId: json['gust_id'] as String?,
      agentConversations: (json['agent_conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AgentModelToJson(AgentModel instance) =>
    <String, dynamic>{
      'agent_work_email': instance.agentWorkEmail,
      'agent_approval_status':
          _$AgentApprovalStatusEnumMap[instance.agentApprovalStatus],
      'agent_domain': instance.agentDomain,
      'agent_conversations': instance.agentConversations,
      'agent_name': instance.agentName,
      'agent_brand': instance.agentBrand,
      'agent_location': instance.agentLocation,
      'agent_zipcode': instance.agentZipCode,
      'agent_image': instance.agentImage,
      'gust_id': instance.gustId,
    };

const _$AgentApprovalStatusEnumMap = {
  AgentApprovalStatus.approved: 'approved',
  AgentApprovalStatus.pending: 'pending',
  AgentApprovalStatus.denied: 'denied',
};
