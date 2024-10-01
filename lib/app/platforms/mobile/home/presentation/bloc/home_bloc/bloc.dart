
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gustosa/app/shared/config/constants/constants.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../auth/domain/usecases/update_user_use_case.dart';

part 'events.dart';

part 'states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final UpdateUserUseCase updateUserUseCase;

  HomePageBloc(this.updateUserUseCase) : super(HomePageInitialState()) {
    on<UpdateHomeScreenIndexEvent>(updateHomeScreenIndexEvent);
    on<UpdateUserProfileEvent>(updateUserProfileEvent);
  }
  Entity entity = defaultEntity;

  int currentIndex = 0;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, so don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, so don't continue
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position
    return await Geolocator.getCurrentPosition();
  }

  FutureOr<void> updateHomeScreenIndexEvent(
      UpdateHomeScreenIndexEvent event, Emitter<HomePageState> emit) {
    emit(ActiveScreenUpdatingState());
    currentIndex = event.index;
    emit(ActiveScreenUpdatedState(event.index));
  }

  FutureOr<void> updateUserProfileEvent(
      UpdateUserProfileEvent event, Emitter<HomePageState> emit) async {
    final supabase = Supabase.instance.client;
    Future<Uint8List> generateImage(prompt) async {
      final response = await post(
          Uri.parse(
              'https://rpmzykoxqnbozgdoqbpc.supabase.co/functions/v1/generate-image'),
          body: jsonEncode({'prompt': prompt}),
          headers: {'Content-Type': 'application/json'});
      return response.bodyBytes;
    }

    Future<String> uploadImage(Uint8List data) async {
      String path =
          "user/${AppLocalStorage.gustId}/profiles/${DateTime.now().toIso8601String()}.png";

      await supabase.storage.from('profiles').uploadBinary(path, data);

      String url = supabase.storage.from('profiles').getPublicUrl(path);
      return url;
    }

    String? getImage() {
      if(AppLocalStorage.user?.dob?.isEmpty ?? true) {
        return null;
      }
      String keyword = 'normal';
      DateTime today = DateTime.now();
      DateTime dob = DateFormat('yyyy-mm-dd').parse(AppLocalStorage.user!.dob!);
      print("dob: $dob");
      int age = today.year - dob.year;
      if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      print("age: $age");
      if(age<20) {
        keyword = 'young';
      } else if(age < 25) {
        keyword = 'genz';
      } else if(age < 50) {
        keyword = 'normal';
      } else if(age < 60) {
        keyword = 'normal';
      } else if(age < 70) {
        keyword = 'older';
      }
      String path = "dummy_profiles/$keyword.png";
      String url = supabase.storage.from('dump').getPublicUrl(path);
      return url;
    }

    String? hushhId = AppLocalStorage.gustId;
    String? generatedAvatarImageUrl;
    print("hushhId::$hushhId");
    if (hushhId != null) {
      emit(UpdatingProfileImageState());
      // String prompt =
      //     "Generate a profile image for a user. User is 20 male. Generate a modern, genz profile image.";
      // final data = await generateImage(prompt);
      // generatedAvatarImageUrl = await uploadImage(data);
      generatedAvatarImageUrl = getImage();
      if(generatedAvatarImageUrl != null) {
        final user =
        AppLocalStorage.user!.copyWith(avatar: generatedAvatarImageUrl);
        await updateUserUseCase(uid: hushhId, user: user);
        AppLocalStorage.updateUser(user);
      }
      emit(ProfileImageUpdatedState());
    }
  }

  FutureOr<void> updateUserRoleEvent(
      UpdateUserRoleEvent event, Emitter<HomePageState> emit) async {
    final user = AppLocalStorage.user?.copyWith(role: event.entity);
    AppLocalStorage.updateUser(user!);
    final result = await updateUserUseCase(uid: user.gustId!, user: user);
    result.fold((l) => null, (r) {
      clearAndReinitializeDependencies();
      Navigator.pushNamedAndRemoveUntil(
          event.context, AppRoutes.splash, (route) => false);
    });
  }
}