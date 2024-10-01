import 'package:either_dart/either.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/user_entity.dart';


abstract class AuthRepository {
  Future<Either<ErrorState,UserEntity?>> signInWithEmail(String email, String password);
  Future<Either<ErrorState,UserEntity?>> signUpWithEmail(String email, String password);
  Future<Either<ErrorState,void>> signOut();
  Future<Either<ErrorState,UserEntity?>> getCurrentUser();
}
