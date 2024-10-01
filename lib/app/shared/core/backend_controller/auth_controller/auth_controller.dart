part of 'auth_controller_impl.dart';

abstract class AuthController {

  User? get firebaseCurrentUser;

  Future<User> signInWithGoogle();

  Future<void> signInWithPhoneFirebase(String phoneNumber, BuildContext context);

  Future<void> verifyPhoneFirebase(String verificationId, String otp);

  Future<void> resendOtpFirebase(String phoneNumber, BuildContext context);

  Future<void> signOut();
}
