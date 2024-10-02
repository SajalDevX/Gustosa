import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/supabase_auth_repository_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';

import '../../../../../shared/core/error_handler/error_state.dart';

class FetchUsersUseCase {
  final SupabaseAuthRepositoryImpl authPageRepository;

  FetchUsersUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<UserEntity>>> call({String? uid, String? email, String? phoneNumber}) async {
    return await authPageRepository.fetchUsers(uid, email, phoneNumber);
  }
}
