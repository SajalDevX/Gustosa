import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/UserEntity.dart';
import 'package:gustosa/app/shared/core/error_handler/ErrorState.dart';

import '../repository/AuthRepository.dart';

class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<Either<ErrorState, UserEntity?>> call(
      String email, String password) async {
    return await repository.signInWithEmail(email, password);
  }
}
