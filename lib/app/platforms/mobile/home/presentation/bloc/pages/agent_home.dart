import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/components/agent_home_page_bottom_navigation_bar.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/utils/toast_manager.dart';

class AgentHomePageArgs {
  final int tabValue;
  final Toast? toast;

  AgentHomePageArgs({required this.tabValue, this.toast});
}

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({Key? key}) : super(key: key);

  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  final controller = sl<HomePageBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)?.settings.arguments as AgentHomePageArgs?;
      int index = args?.tabValue ?? 1;
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
      body: BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          final tabIndex = state is ActiveScreenUpdatedState ? state.index : 1;
          return [
            const Placeholder(), //ChatHistoryView(),
            const Placeholder(),
            const Placeholder(),
          ].elementAt(tabIndex);
        },
      ),
      bottomNavigationBar: const AgentHomePageBottomNavigationBar(),
    );
  }
}
