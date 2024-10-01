import 'package:either_dart/either.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../repository/supabase_auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<Either<ErrorState, void>> call() async {
    return await authRepository.signOut();
  }
}
