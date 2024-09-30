import 'package:flutter/material.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String share = '/share';
  static const String agentSignUp = '/agent-sign-up';
  static const String agentCategories = '/agent-categories';
  static const String userSignUp = '/user-sign-up';
  static const String emailVerification = '/email-verification';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String agentHome = '/agent-home';
  static const String agentStatus = '/agent-status';
  static const String agentDashboard = '/agent-dashboard';
  static const String agentNewTask = '/agent-new-task';
  static const String agentCreateMeeting = '/agent-meeting';
  static const String agentMeetingInfo = '/agent-meeting-info';
  static const String agentProfile = '/agent-profile';
  static const String agentLookbook = '/agent-lookbook';
  static const String agentProducts = '/agent-products';
  static const String agentHushhMeet = '/agent-hushh-meet';
  static const String userHushhMeet = '/user-hushh-meet';
  static const String browsingAnalytics = '/browsing-analytics';
  static const String wishlistProducts = '/wishlist-products';
  static const String agentEditProfile = '/agent-edit-profile';

  static const String mainAuth = '/main-auth';
  static const String newTutorial = '/new-tutorial';
}


class NavigationManager {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.initial: (context) => const SplashPage(),
    AppRoutes.splash: (context) => const SplashPage(),
    AppRoutes.mainAuth: (context) => const MainAuthPage(),
    AppRoutes.newTutorial: (context) => const NewTutorialPage(),
    AppRoutes.agentSignUp: (context) => const AgentSignUpPage(),
    AppRoutes.agentCategories: (context) => const AgentCategoriesPage(),
    AppRoutes.emailVerification: (context) => const EmailVerificationPage(),
    AppRoutes.otpVerification: (context) => const OtpVerificationPage(),
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.agentHome: (context) => const AgentHomePage(),
  };
}
