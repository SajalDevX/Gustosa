import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';

import '../../../../../shared/core/error_handler/error_state.dart';

class UpdateUserUseCase {
  final SupabaseAuthRepositoryImpl authPageRepository;

  UpdateUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required UserEntity user, required String uid}) async {
    return await authPageRepository.updateUser(user, uid);
  }
}
