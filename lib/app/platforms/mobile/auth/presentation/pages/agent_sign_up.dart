import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/agent_sign_up_app_bar.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/pages/email_verification.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/components/agent_text_field.dart';
import 'package:gustosa/app/shared/core/components/hushh_agent_button.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';


class AgentSignUpPage extends StatefulWidget {
  const AgentSignUpPage({super.key});

  @override
  State<AgentSignUpPage> createState() => _AgentSignUpPageState();
}

class _AgentSignUpPageState extends State<AgentSignUpPage> {
  final controller = sl<AgentSignUpPageBloc>();

  @override
  void initState() {
    controller.nameController.clear();
    controller.brandController.clear();
    controller.emailController.clear();
    controller.locationController.clear();
    controller.zipCodeController.clear();
    controller.agentImage = null;
    controller.agentImageExt = null;
    controller.add(FetchCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AgentSignUpAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 56,
                child: HushhLinearGradientButton(
                  text: 'Finish Setup',
                  enabled: controller.isValidated,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.emailVerification,
                        arguments: EmailVerificationPageArgs(
                            controller.emailController.text));
                  },
                ),
              ),
            );
          }
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Stack(
                children: [
                  BlocBuilder(
                      bloc: controller,
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            controller.add(CaptureImageEvent());
                          },
                          child: CircleAvatar(
                            radius: 12.w,
                            foregroundImage: (controller.agentImage == null
                                ? const AssetImage('assets/user.png')
                                : MemoryImage(controller.agentImage!)
                            as ImageProvider),
                          ),
                        );
                      }),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color(0XFFA342FF),
                          Color(0XFFE54D60),
                        ]),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                  isAuthTextField: true,
                  controller: controller.nameController,
                  onChanged: (_) => setState(() {}),
                  fieldType: CustomFormType.text,
                  hintText: "Enter name"),
              CustomTextField(
                  isAuthTextField: true,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  controller: controller.emailController,
                  fieldType: CustomFormType.text,
                  hintText: "Enter email"),
              CustomTextField(
                    isAuthTextField: true,
                    controller: controller.locationController,
                    onChanged: (_) => setState(() {}),
                    fieldType: CustomFormType.text,
                    hintText: "City, State, Country"),
              CustomTextField(
                  isAuthTextField: true,
                  controller: controller.zipCodeController,
                  onChanged: (_) => setState(() {}),
                  textInputType: TextInputType.number,
                  fieldType: CustomFormType.text,
                  hintText: "Zipcode"),
            ],
          ),
        ),
      ),
    );
  }
}
