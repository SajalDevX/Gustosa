import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/pages/agent_home.dart';
import 'package:gustosa/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import 'package:lottie/lottie.dart';
import '../../../../../shared/core/utils/nfc_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller = sl<SplashPageBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.add(InitializeEvent());
      if (AppLocalStorage.isUserLoggedIn) {
        NfcUtils().checkForNfcSupport(NfcOperation.read, context);
      }
    });
  }

  @override
  void dispose() {
    controller.add(DisposeEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer(
          listener: (context, state) async {
            if (state is SplashPageLoadedState) {
              switch (controller.onboardStatus) {
                case UserOnboardStatus.initial:
                case UserOnboardStatus.onboardDone:
                case UserOnboardStatus.signUpForm:
                  if (kIsWeb) {
                    final Uri uri = Uri.base;
                    final Map<String, String> queryParams = uri.queryParameters;
                    debugPrint('$queryParams');
                    if (queryParams.containsKey('uid') &&
                        queryParams.containsKey('data')) {
                      int? brandIdAsInt =
                          int.tryParse(queryParams['data'] ?? '');
                    }
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.mainAuth);
                  }
                  break;
                case UserOnboardStatus.loggedIn:
                  print(
                      "sl<HomePageBloc>().entity: ${sl<HomePageBloc>().entity}");
                  if (sl<HomePageBloc>().entity == Entity.user) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else if (sl<HomePageBloc>().entity == Entity.agent) {
                    switch (AppLocalStorage.agent!.agentApprovalStatus!) {
                      case AgentApprovalStatus.approved:
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.agentHome,
                            arguments: AgentHomePageArgs(tabValue: 1));
                        break;
                      case AgentApprovalStatus.pending:
                      case AgentApprovalStatus.denied:
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.agentStatus,
                            arguments:
                                AppLocalStorage.agent!.agentApprovalStatus!);
                        break;
                    }
                  }
                  break;
              }
            }
          },
          bloc: controller,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!kIsWeb)
                    Transform.scale(
                        scale: 1.5,
                        child: Lottie.asset('assets/splash-anim.json',
                            repeat: false))
                  else
                    Image.asset('assets/splash.gif')
                ],
              ),
            );
          }),
    );
  }
}
