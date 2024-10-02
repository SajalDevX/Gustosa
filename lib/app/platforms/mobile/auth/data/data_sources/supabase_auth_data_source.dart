import '../../../../../shared/config/constants/enums.dart';
import '../../domain/entities/user_entity.dart';

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
  Future<void> insertUser(UserEntity userModel);

  Future<void> updateUser(UserEntity userModel, String uid);
}
