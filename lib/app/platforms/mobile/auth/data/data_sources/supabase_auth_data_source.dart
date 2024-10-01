import 'package:gustosa/app/shared/config/constants/enums.dart';
import '../../domain/entities/agent_model.dart';
import '../../domain/entities/user_model.dart';

abstract class SupabaseAuthDataSource {
  Future<Map<String, dynamic>?> fetchUser(
    String? uid,
    String? email,
    String? phoneNumber,
    AgentApprovalStatus? approvalStatus,
  );

  Future<List<Map<String, dynamic>>> fetchUsers(
    String? uid,
    String? email,
    String? phoneNumber,
  );

  Future<void> insertUser(UserModel userModel);

  Future<void> updateUser(UserModel userModel, String uid);

  Future<void> updateAgent(AgentModel agent);

  Future<void> insertAgent(AgentModel agent);

  Future<List<Map<String, dynamic>>> fetchAgents(
    String? uid,
    String? email,
    AgentApprovalStatus? approvalStatus,
  );
}
