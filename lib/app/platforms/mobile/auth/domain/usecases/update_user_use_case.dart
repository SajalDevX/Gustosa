
import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';

import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_model.dart';

class UpdateUserUseCase {
  final AuthRepositoryImpl authPageRepository;

  UpdateUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required UserModel user, required String uid}) async {
    return await authPageRepository.updateUser(user, uid);
  }
}
