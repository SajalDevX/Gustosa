

import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';

import '../../../../../shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';

class FetchUserUseCase {
  final SupabaseAuthRepositoryImpl authPageRepository;

  FetchUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, UserEntity?>> call({String? uid, String? email, String? phoneNumber, AgentApprovalStatus? approvalStatus}) async {
    return await authPageRepository.fetchUser(uid, email, phoneNumber, approvalStatus);
  }
}
