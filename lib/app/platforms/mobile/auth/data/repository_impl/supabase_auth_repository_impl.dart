import 'package:either_dart/either.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/supabase_auth_repository.dart';
import '../data_sources/supabase_auth_data_source.dart';

class SupabaseAuthRepositoryImpl implements SupabaseAuthRepository {
  final SupabaseAuthDataSource authDataSource;

  SupabaseAuthRepositoryImpl(this.authDataSource);

  @override
  Future<Either<ErrorState, UserEntity?>> fetchUser(
      String? uid, String? email, String? phoneNumber, AgentApprovalStatus? approvalStatus) async {
    try {
      final result = await authDataSource.fetchUser(uid, email, phoneNumber, approvalStatus);
      if (result != null) {
        return Right(UserEntity.fromJson(result));
      } else {
        return Left(DataHttpError(HttpException.unknown));
      }
    } catch (e) {
      return Left(DataHttpError(HttpException.unknown));
    }
  }

  @override
  Future<Either<ErrorState, List<UserEntity>>> fetchUsers(
      String? uid, String? email, String? phoneNumber) async {
    try {
      final result = await authDataSource.fetchUsers(uid, email, phoneNumber);
      final users = result.map<UserEntity>((e) => UserEntity.fromJson(e)).toList();
      return Right(users);
    } catch (e) {
      return  Left(DataHttpError(HttpException.unknown));
    }
  }

  @override
  Future<Either<ErrorState, void>> insertUser(UserEntity user) async {
    try {
      await authDataSource.insertUser(user);
      return const Right(null);
    } catch (e) {
      return Left(DataHttpError(HttpException.unknown));
    }
  }

  @override
  Future<Either<ErrorState, void>> updateUser(UserEntity user, String uid) async {
    try {
      await authDataSource.updateUser(user, uid);
      return const Right(null);
    } catch (e) {
      return Left(DataHttpError(HttpException.unknown));
    }
  }
}
