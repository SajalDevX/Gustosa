
import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/UserEntity.dart';

import '../../../../../shared/core/error_handler/ErrorState.dart';
import '../repository/AuthRepository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<ErrorState, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
