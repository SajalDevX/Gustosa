import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gustosa/app/platforms/mobile/splash/presentation/bloc/onboarding_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/splash/presentation/components/onboarding_page_indicator.dart';
import 'package:gustosa/app/shared/config/constants/data.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';



bool isUser = true;
bool? onFormStatus = false;

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final controller = sl<OnboardingPageBloc>();

  @override
  void initState() {
    controller.pageController = PageController();
    controller.pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
          bloc: controller,
          listener: (context, state) {
            if (state is OnboardingPageOnLastPageState) {
              Navigator.pushNamed(context, AppRoutes.mainAuth);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 10, right: 10, bottom: 50),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: PageView(
                          controller: controller.pageController,
                          children: onboardDataList,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: controller.initializeController(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const SizedBox();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: Text(controller.lastPage ? "" : "Skip",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                              onPressed: () {
                                controller.add(
                                  OnPageUpdatedEvent(
                                      onboardDataList.length - 1));
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                child: Row(
                                  children: List.generate(
                                      3,
                                      (index) => OnboardingPageIndicator(
                                          currentIndex: controller.currentPage,
                                          index: index)),
                                ),
                              ),
                            ),
                            TextButton(
                                child: ShaderMask(
                                  shaderCallback: (shader) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0XFFA342FF),
                                        Color(0XFFE54D60),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ).createShader(shader);
                                  },
                                  child: const Text("Next",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ),
                                onPressed: () =>
                                    controller.add(OnNextPageIndexEvent())),
                          ],
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}
