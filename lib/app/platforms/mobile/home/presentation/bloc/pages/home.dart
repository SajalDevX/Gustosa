import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/components/home_page_bottom_navigation_bar.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/utils/toast_manager.dart';


class HomePageArgs {
  final int tabValue;
  final Toast? toast;

  HomePageArgs({required this.tabValue, this.toast});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = sl<HomePageBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)?.settings.arguments as HomePageArgs?;
      int index = args?.tabValue ?? 0;
      controller.add(UpdateHomeScreenIndexEvent(index, context));
      if (args?.toast != null) {
        ToastManager(args!.toast!).show(context);
      }
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (_) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
        child: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            final tabIndex = controller.currentIndex;
            return [
              const Placeholder(),
              const Placeholder(),
              const Placeholder(),
              const Placeholder(),
            ].elementAt(tabIndex);
          },
        ),
      ),
      bottomNavigationBar: const HomePageBottomNavigationBar(),
    );
  }
}
