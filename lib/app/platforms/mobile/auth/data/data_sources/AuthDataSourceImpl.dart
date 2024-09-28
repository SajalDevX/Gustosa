import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/UserEntity.dart';
import 'AuthDataSource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthDataSourceImpl(this._firebaseAuth);

  Future<UserEntity?> signInWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(id: result.user!.uid, email: result.user!.email!);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserEntity?> getCurrentUser() async{
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return UserEntity(id: firebaseUser.uid, email: firebaseUser.email!);
    }
    return null;
  }

  @override
  Future<UserEntity?> signUpWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(id: result.user!.uid, email: result.user!.email!);
    } catch (e) {
      return null;
    }
  }

}

