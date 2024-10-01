import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:gustosa/app/shared/config/constants/enums.dart';

part 'agent_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class AgentModel {
  @HiveField(1)
  @JsonKey(name: 'agent_work_email')
  final String? agentWorkEmail;

  @HiveField(2)
  @JsonKey(name: 'agent_approval_status')
  final AgentApprovalStatus? agentApprovalStatus;

  @HiveField(3)
  @JsonKey(name: 'agent_domain')
  final String? agentDomain;

  @HiveField(4)
  @JsonKey(name: 'agent_conversations')
  List<String>? agentConversations;

  @HiveField(5)
  @JsonKey(name: 'agent_name')
  final String? agentName;

  @HiveField(6)
  @JsonKey(name: 'agent_brand')
  final Map<String, dynamic>? agentBrand;

  @HiveField(7)
  @JsonKey(name: 'agent_location')
  final String? agentLocation;

  @HiveField(8)
  @JsonKey(name: 'agent_zipcode')
  final String? agentZipCode;

  @HiveField(9)
  @JsonKey(name: 'agent_image')
  final String? agentImage;

  @HiveField(10)
  @JsonKey(name: 'gust_id')
  final String? gustId;

  AgentModel({
    this.agentWorkEmail,
    this.agentApprovalStatus,
    this.agentDomain,
    this.agentName,
    this.agentBrand,
    this.agentLocation,
    this.agentZipCode,
    this.agentImage,
    this.gustId,
    this.agentConversations
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) =>
      _$AgentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgentModelToJson(this);

  AgentModel copyWith({
    String? agentWorkEmail,
    AgentApprovalStatus? agentApprovalStatus,
    String? agentDomain,
    List<String>? agentConversations,
    String? agentName,
    Map<String, dynamic>? agentBrand,
    String? agentLocation,
    String? agentZipCode,
    String? agentImage,
    String? gustId,
  }) {
    return AgentModel(
      agentWorkEmail: agentWorkEmail ?? this.agentWorkEmail,
      agentApprovalStatus: agentApprovalStatus ?? this.agentApprovalStatus,
      agentDomain: agentDomain ?? this.agentDomain,
      agentConversations: agentConversations ?? this.agentConversations,
      agentName: agentName ?? this.agentName,
      agentBrand: agentBrand ?? this.agentBrand,
      agentLocation: agentLocation ?? this.agentLocation,
      agentZipCode: agentZipCode ?? this.agentZipCode,
      agentImage: agentImage ?? this.agentImage,
      gustId: gustId ?? this.gustId,
    );
  }
}
