import 'package:either_dart/either.dart';
import 'package:gustosa/app/shared/core/error_handler/ErrorState.dart';
import '../repository/AuthRepository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<Either<ErrorState, void>> call() async {
    return await authRepository.signOut();
  }
}
