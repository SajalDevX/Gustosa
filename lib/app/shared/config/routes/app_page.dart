import 'package:get/get.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/pages/personal_details_screen.dart';
import 'package:gustosa/app/platforms/mobile/home/home_page.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';

import '../../../platforms/mobile/auth/presentation/pages/welcome_page.dart';

class AppPage {
  static List<GetPage> list = [
    GetPage(name: AppRoutes.home, page: HomeScreen.new),
    GetPage(name: AppRoutes.welcomeScreen, page: WelcomePageBuilder.new),
    GetPage(name: AppRoutes.authUserDetails, page: AuthSignUpPage.new),
  ];
}