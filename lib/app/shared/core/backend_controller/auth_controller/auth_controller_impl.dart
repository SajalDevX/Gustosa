import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../config/constants/secrets.dart';
import '../../error_handler/error_state.dart';

part 'auth_controller.dart';

class AuthControllerImpl extends AuthController {
  final supabase = Supabase.instance.client;
  final fa.FirebaseAuth _firebaseAuth = fa.FirebaseAuth.instance;

  @override
  User? get currentUser => supabase.auth.currentUser;

  @override
  fa.User? get firebaseCurrentUser => _firebaseAuth.currentUser;

  @override
  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Secrets.getIosId(), serverClientId: Secrets.WEB_CLIENT_ID);
    final value = await googleSignIn.isSignedIn();
    final GoogleSignInAccount? googleSignInAccount;
    if (value) {
      await googleSignIn.signOut();
    }
    googleSignInAccount = await googleSignIn.signIn();
    final googleAuth = await googleSignInAccount!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<ResendResponse> resendOtp(String phoneNumber) async {
    return await supabase.auth.resend(type: OtpType.sms, phone: phoneNumber);
  }

  @override
  Future<void> resendOtpFirebase(String phoneNumber, BuildContext context) async{
    await signInWithPhoneFirebase(phoneNumber, context);
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }
    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<Either<ErrorState, void>> signInWithEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithPhone(String phoneNumber) async {
    await supabase.auth.signInWithOtp(
      phone: phoneNumber,
      shouldCreateUser: true,
      channel: OtpChannel.sms,
    );
  }

  @override
  Future<void> signInWithPhoneFirebase(
      String phoneNumber, BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fa.PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (fa.FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          sl<AuthPageBloc>().setVerificationId(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          sl<AuthPageBloc>().setVerificationId(verificationId);
        },
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  @override
  Future<void> signOut() async{
    await supabase.auth.signOut();
  }

  @override
  Future<AuthResponse> verifyPhone(String otp, String phoneNumber,
      [bool isPhoneChange = false]) async {
    return await supabase.auth.verifyOTP(
        token: otp,
        type: isPhoneChange ? OtpType.phoneChange : OtpType.sms,
        phone: phoneNumber);
  }

  @override
  Future<void> verifyPhoneFirebase(String verificationId, String otp) async {
    try {
      final fa.PhoneAuthCredential credential = fa.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Failed to verify OTP: $e');
    }
  }

  @override
  Future<ResendResponse> resendEmailOtp(String email) async{
    return await supabase.auth.resend(type: OtpType.signup, email: email);
  }

  @override
  Future<AuthResponse?> verifyEmail(String otp, String email) async{
    try {
      return await supabase.auth.verifyOTP(
          token: otp,
          type: OtpType.magiclink,
          email: email
      );
    }catch(error) {
      return null;
    }
  }
}
