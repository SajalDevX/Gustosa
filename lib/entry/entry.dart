import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import '../app/shared/config/routes/app_page.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});

  String checkUser() {
    var startPage = AppRoutes.welcomeScreen;
    final user = AppLocalStorage.user;
    if (user != null) {
      if (user.onboardStatus == OnboardStatus.signed_up) {
        startPage = AppRoutes.home;
      } else if (user.onboardStatus == OnboardStatus.authenticated) {
        startPage = AppRoutes.authUserDetails;
      }
    }
    return startPage;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
      debugShowCheckedModeBanner: false,
      getPages: AppPage.list,
      initialRoute: checkUser(),
    );
  }
}
