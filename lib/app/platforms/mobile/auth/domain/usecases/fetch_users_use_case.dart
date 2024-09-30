import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';

import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_model.dart';

class FetchUsersUseCase {
  final AuthRepositoryImpl authPageRepository;

  FetchUsersUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<UserModel>>> call({String? uid, String? email, String? phoneNumber}) async {
    return await authPageRepository.fetchUsers(uid, email, phoneNumber);
  }
}
