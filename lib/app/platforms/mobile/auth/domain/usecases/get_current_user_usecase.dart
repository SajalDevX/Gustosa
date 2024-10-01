
import 'package:either_dart/either.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_entity.dart';
import '../repository/supabase_auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<ErrorState, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
