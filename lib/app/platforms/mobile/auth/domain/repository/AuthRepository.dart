import 'package:either_dart/either.dart';
import 'package:gustosa/app/shared/core/error_handler/ErrorState.dart';

import '../entities/UserEntity.dart';

abstract class AuthRepository {
  Future<Either<ErrorState,UserEntity?>> signInWithEmail(String email, String password);
  Future<Either<ErrorState,UserEntity?>> signUpWithEmail(String email, String password);
  Future<Either<ErrorState,void>> signOut();
  Future<Either<ErrorState,UserEntity?>> getCurrentUser();
}
