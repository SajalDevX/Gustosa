import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/UserEntity.dart';
import 'package:gustosa/app/shared/core/error_handler/ErrorState.dart';

import '../repository/AuthRepository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository authRepository;

  SignUpWithEmailUseCase(this.authRepository);

  Future<Either<ErrorState, UserEntity?>> call(
      String email, String password) async {
    return await authRepository.signUpWithEmail(email, password);
  }
}
