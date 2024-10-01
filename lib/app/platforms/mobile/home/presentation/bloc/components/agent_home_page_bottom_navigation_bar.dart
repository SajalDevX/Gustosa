import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/config/assets/icon.dart';
import 'package:gustosa/app/shared/config/constants/colors.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';

class AgentHomePageBottomNavigationBar extends StatelessWidget {
  const AgentHomePageBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<HomePageBloc>();
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          final tabIndex = state is ActiveScreenUpdatedState ? state.index : 1;
          return BottomNavigationBar(
            onTap: (int index) =>
                controller.add(UpdateHomeScreenIndexEvent(index, context)),
            backgroundColor: Colors.white,
            currentIndex: tabIndex,
            selectedItemColor: CustomColors.projectBaseBlue,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.chatIcon,
                  color: tabIndex == 0
                      ? CustomColors.projectBaseBlue
                      : Colors.black,
                ),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/wallet_icon.svg",
                  color: tabIndex == 1
                      ? CustomColors.projectBaseBlue
                      : Colors.black,
                ),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/settings_icon.svg",
                  color: tabIndex == 2
                      ? CustomColors.projectBaseBlue
                      : Colors.black,
                ),
                label: "Settings",
              ),
            ],
            // curve: Curves.easeInBack,
          );
        });
  }
}
