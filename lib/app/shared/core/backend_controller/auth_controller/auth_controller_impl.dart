import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';

import '../../inject_dependency/dependencies.dart';

part 'auth_controller.dart';

class AuthControllerImpl extends AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get firebaseCurrentUser => _firebaseAuth.currentUser;

  @override
  Future<void> resendOtpFirebase(
      String phoneNumber, BuildContext context) async {
    await signInWithPhoneFirebase(phoneNumber, context);
  }

  @override
  Future<GoogleSignInAccount?> initiateGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      return googleUser;
    }
    return null;
  }

  @override
  Future<User?> completeGoogleSignIn(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential firebaseUser = await _firebaseAuth.signInWithCredential(credential);
    return firebaseUser.user;
  }

  @override
  Future<void> signInWithPhoneFirebase(
      String phoneNumber, BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _firebaseAuth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (kDebugMode) {
              print('Verification failed : ${e.message}');
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            sl<AuthBloc>().setVerificationId(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            sl<AuthBloc>().setVerificationId(verificationId);
          });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to verify phone number: $e');
      }
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> verifyPhoneFirebase(String verificationId, String otp) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      return result.user!;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to verify OTP: $e');
      }
    }
    return null;
  }
}
