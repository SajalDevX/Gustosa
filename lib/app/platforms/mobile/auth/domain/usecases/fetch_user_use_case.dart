
import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';

import '../../../../../shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_model.dart';

class FetchUserUseCase {
  final AuthRepositoryImpl authPageRepository;

  FetchUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, UserModel?>> call({String? uid, String? email, String? phoneNumber, AgentApprovalStatus? approvalStatus}) async {
    return await authPageRepository.fetchUser(uid, email, phoneNumber, approvalStatus);
  }
}
