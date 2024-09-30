import 'package:either_dart/either.dart';
import '../../../../../shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../../../../../shared/core/error_handler/error_handler.dart';
import '../../domain/entities/agent_model.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/supabase_auth_data_source_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSourceImpl authPageSupabaseDataSource;

  AuthRepositoryImpl(this.authPageSupabaseDataSource);

  @override
  Future<Either<ErrorState, UserModel?>> fetchUser(
      String? uid, String? email, String? phoneNumber, AgentApprovalStatus? approvalStatus) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.fetchUser(uid, email, phoneNumber, approvalStatus),
            (value) {
          final result = value as Map<String, dynamic>?;
          return result != null ? UserModel.fromJson(result) : null;
        });
  }

  @override
  Future<Either<ErrorState, void>> insertUser(UserModel user) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.insertUser(user), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateUser(UserModel user, String uid) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.updateUser(user, uid), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateAgent(AgentModel agent) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.updateAgent(agent), (value) {});
  }

  @override
  Future<Either<ErrorState, List<UserModel>>> fetchUsers(String? uid, String? email, String? phoneNumber) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.fetchUsers(uid, email, phoneNumber),
            (value) {
          final result = value as List<Map<String, dynamic>>;
          return result.map((e) => UserModel.fromJson(e)).toList();
        });
  }

  @override
  Future<Either<ErrorState, void>> insertAgent(AgentModel agent) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.insertAgent(agent), (value) {});
  }

  @override
  Future<Either<ErrorState, List<AgentModel>>> fetchAgents(String? uid, String? email, AgentApprovalStatus? approvalStatus) async {
    return await ErrorHandler.callSupabase(
            () => authPageSupabaseDataSource.fetchAgents(uid, email, approvalStatus),
            (value) {
          final result = value as List<Map<String, dynamic>>;
          return result.map((e) => AgentModel.fromJson(e)).toList();
        });
  }
}
