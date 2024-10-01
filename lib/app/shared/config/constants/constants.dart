


import 'package:flutter/cupertino.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';

const receiptRadarCoins = 20;
const healthInsightsCoins = 10;

Entity defaultEntity = Entity.user;

class Constants {
  static const offlineAlert = "Please check your internet connection!";
  static const encryptionKey = "goodwillhush2023";
  static const exitText = "Press again to exit!";
  static const logIn = "Log in";
  static const getStarted = "Get Started";
  static const signUp = "Sign up";
  static const yourName = "Tell us your name";
  static const yourDateOfBirth = "Tell us your date of birth";
  static const yourEmailAddress = "Tell us your email address";
  static const yourEmail = "Your Email";
  static const yourPhoneNumber = "Phone number";
  static const password = "Password";
  static const otp = "OTP";
  static const enterEmail = "Email is Required!";
  static const enterName = "name required";
  static const enterDateOfBirth = "D.O.B required";
  static const enterNumber = "Phone number required";
  static const enterValidEmail = "Email must be valid!";
  static const emailVerificationLink = "Email verification link has been sent!";
  static const enterPassword = "Password required";
  static const enterOtp = "OTP required";
  static const loading = "Loading..";
  static const invalidVerificationCode = "Invalid verification code";
  static const invalidPhoneNumber = "Invalid phone number";
  static const pleaseTryAgain = "Please try again after some time!";
  static const fileFormatNotSupported = "File format not supported!";
  static const sessionExpired = "Session expired. Please try again!";

  //On board screen texts
  static const skip = "Skip";
  static const onBoardScreenFirstTextControl =
      "Control and manage your data with your privacy first choices";
  static const onBoardScreenSecondTextMineYour =
      "Mine your data into monetary assets like coins";

  //Sign up screen texts
  static const enterYourDetails = "Enter your details below & free sign up";
  static const createAccount = "Sign in";
  static const next = "Next";
  static const signUpCheckText =
      "By creating an account you have to agree with our terms & conditions.";
  static const alreadyHaveAccount = "Already have an account?";
  static const loginWithPhoneNumber = "login with phone number & otp";
  static const signUpCheck =
      "Please agree our terms & conditions before sign up";
  static const passwordTooWeak = "The password provided is too weak.";
  static const accountAlreadyExist =
      "The account already exists for that email. Please Sign in!";
  static const verifyEmail = "VERIFY YOUR EMAIL ADDRESS";

  //Login screen texts
  static const forgotPassword = "Forgot password?";
  static const doNotHaveAccount = "Don't have an account?";
  static const orLoginWith = "Or login with";
  static const userNotFound = "You haven't signed up yet. Please sign up!";
  static const incorrectCredentials = "Incorrect Credentials";

  //Forgot password tets
  static const proceed = "Proceed";
  static const StripeSecretKeyTest =
      "sk_test_51M2VQ0LYaD0u4Aj1Khu5C5vYZXO08vLUluF2FSD5yYp8QFF8EIuddEAkWmzc3bLX0nYDgrqMOs8Yn1uoC6vp6RRD00G1Is6hz4";
  static const StripeSecretKeyLive =
      "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";

  static const int otpLength = 6;

  static const String financeCardId =
      "4f5ce873ce7fd13c7e2f059e94e24e4c7c66816c";

  static const int healthCardId = 130;

  static const int browseCardId = 65;

  static const String baseUrl = String.fromEnvironment('base_url');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
