import 'package:either_dart/either.dart';

import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_entity.dart';
import '../repository/supabase_auth_repository.dart';


class SignUpWithEmailUseCase {
  final AuthRepository authRepository;

  SignUpWithEmailUseCase(this.authRepository);

  Future<Either<ErrorState, UserEntity?>> call(
      String email, String password) async {
    return await authRepository.signUpWithEmail(email, password);
  }
}
