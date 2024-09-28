import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../shared/core/error_handler/ErrorState.dart';
import '../../domain/entities/UserEntity.dart';
import '../../domain/repository/AuthRepository.dart';
import '../data_sources/AuthDataSource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<Either<ErrorState, UserEntity>> signInWithEmail(String email, String password) async {
    try {
      final user = await authDataSource.signInWithEmail(email, password);  // Call the data source
      return Right(user!);
    } on FirebaseAuthException catch (e) {
      return Left(DataClientError(Exception(e.message)));
    } catch (e) {
      return Left(DataParseError(Exception(e.toString())));
    }
  }

  @override
  Future<Either<ErrorState, UserEntity>> signUpWithEmail(String email, String password) async {
    try {
      final user = await authDataSource.signUpWithEmail(email, password);  // Call the data source
      return Right(user!);
    } on FirebaseAuthException catch (e) {
      return Left(DataClientError(Exception(e.message)));
    } catch (e) {
      return Left(DataParseError(Exception(e.toString())));
    }
  }

  @override
  Future<Either<ErrorState, void>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(DataParseError(Exception(e.toString())));
    }
  }

  @override
  Future<Either<ErrorState, UserEntity>> getCurrentUser() async {
    try {
      final user = await authDataSource.getCurrentUser();
      if (user != null) {
        return Right(user);
      } else {
        return Left(DataClientError(Exception('No user currently signed in.')));
      }
    } catch (e) {
      return Left(DataParseError(Exception(e.toString())));
    }
  }
}
