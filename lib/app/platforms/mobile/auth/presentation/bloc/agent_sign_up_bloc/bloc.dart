import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../../../../../shared/core/local_storage/local_storage.dart';
import '../../../../../../shared/core/utils/toast_manager.dart';
import '../../../domain/entities/agent_model.dart';
import '../../../domain/usecases/update_agent_use_case.dart';

part 'events.dart';

part 'states.dart';

class AgentSignUpPageBloc
    extends Bloc<AgentSignUpPageEvent, AgentSignUpPageState> {
  final UpdateAgentUseCase updateAgentUseCase;

  AgentSignUpPageBloc(this.updateAgentUseCase)
      : super(AgentSignUpPageInitialState()) {
    on<FetchCategoriesEvent>(fetchCategoriesEvent);
    on<CaptureImageEvent>(captureImageEvent);
    on<UpdateAgentEvent>(updateAgentEvent);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  Uint8List? agentImage;
  String? agentImageExt;

  bool get isValidated =>
      nameController.text.trim().isNotEmpty &&
      brandController.text.trim().isNotEmpty &&
      locationController.text.trim().isNotEmpty &&
      zipCodeController.text.trim().isNotEmpty &&
      descController.text.trim().isNotEmpty &&
      agentImage != null;


  FutureOr<void> captureImageEvent(
      CaptureImageEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(CapturingImageState());
    XFile? result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      agentImage = (await result.readAsBytes()) as Uint8List?;
      agentImageExt = result.path.split('.').lastOrNull ?? "png";
      emit(ImageCapturedState());
    }
  }

  FutureOr<void> updateAgentEvent(
      UpdateAgentEvent event, Emitter<AgentSignUpPageState> emit) async {
    emit(UpdatingAgentState());
    String? uri;
    showDialog(
      context: event.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: const CupertinoActivityIndicator(),
              // You can customize the dialog further if needed
            ),
          ],
        );
      },
    );
    if (agentImage != null) {
      final reference = FirebaseStorage.instance.ref().child(
          'agent_profiles/${const Uuid().v4()}.${sl<AgentSignUpPageBloc>().agentImageExt}');
      await reference.putData(sl<AgentSignUpPageBloc>().agentImage);
      uri = await reference.getDownloadURL();
    }
    AgentModel agent = AppLocalStorage.agent!.copyWith(
      agentWorkEmail: sl<AgentSignUpPageBloc>().emailController.text,
      agentImage: uri,
      agentName: sl<AgentSignUpPageBloc>().nameController.text,
      agentLocation: sl<AgentSignUpPageBloc>().locationController.text,
      agentZipCode: sl<AgentSignUpPageBloc>().zipCodeController.text,
    );

    final result = await updateAgentUseCase(agent: agent);
    await result.fold((l) {
      Navigator.pop(event.context);
      ToastManager(Toast(
          title: "some error occurred",
          type: ToastificationType.error
      )).show(event.context);
    }, (r) async {
      AppLocalStorage.updateAgent(agent);
      ToastManager(Toast(
          title: "Your profile updated successfully!",
          type: ToastificationType.success
      )).show(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      emit(UpdatedAgentState());
    });
  }
}
