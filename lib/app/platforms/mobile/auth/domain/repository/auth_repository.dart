import 'package:either_dart/either.dart';
import 'package:gustosa/app/shared/core/error_handler/error_state.dart';

import '../../../../../shared/config/constants/enums.dart';
import '../entities/agent_model.dart';
import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<Either<ErrorState, UserModel?>> fetchUser(
      String? uid,
      String? email,
      String? phoneNumber,
      AgentApprovalStatus? approvalStatus,
      );

  Future<Either<ErrorState, List<UserModel>>> fetchUsers(
      String? uid,
      String? email,
      String? phoneNumber,
      );

  Future<Either<ErrorState, void>> insertUser(UserModel user);

  Future<Either<ErrorState, void>> insertAgent(AgentModel agent);

  Future<Either<ErrorState, void>> updateUser(UserModel user, String uid);

  Future<Either<ErrorState, void>> updateAgent(AgentModel agent);

  Future<Either<ErrorState, List<AgentModel>>> fetchAgents(
      String? uid,
      String? email,
      AgentApprovalStatus? approvalStatus,
      );
}
