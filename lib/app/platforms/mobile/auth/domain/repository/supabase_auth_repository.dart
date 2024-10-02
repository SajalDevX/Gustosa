import 'package:either_dart/either.dart';
import '../../../../../shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_entity.dart';

abstract class SupabaseAuthRepository {
  Future<Either<ErrorState, void>> insertUser(UserEntity user);

  Future<Either<ErrorState, UserEntity?>> fetchUser(
    String? uid,
    String? email,
    String? phoneNumber,
    AgentApprovalStatus? approvalStatus,
  );

  Future<Either<ErrorState, List<UserEntity>>> fetchUsers(
    String? uid,
    String? email,
    String? phoneNumber,
  );

  Future<Either<ErrorState, void>> updateUser(UserEntity user, String uid);
}
