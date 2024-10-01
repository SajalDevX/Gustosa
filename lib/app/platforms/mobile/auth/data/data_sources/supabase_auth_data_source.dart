import '../../domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
