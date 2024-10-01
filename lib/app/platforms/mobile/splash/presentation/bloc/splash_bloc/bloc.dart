import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';

part 'events.dart';
part 'states.dart';

class SplashPageBloc extends Bloc<SplashPageEvent, SplashPageState> {
  double visibility = 0;

  UserOnboardStatus get onboardStatus => AppLocalStorage.userOnboardStatus;

  SplashPageBloc() : super(SplashPageInitialState()) {
    on<InitializeEvent>(initializeEvent);
    on<DisposeEvent>(disposeEvent);
    on<OnVideoEndEvent>(onVideoEndEvent);
  }

  Future<void> _initialize() async {
    FlutterImageCompress.showNativeLog = true;
  }


  FutureOr<void> initializeEvent(
      InitializeEvent event, Emitter<SplashPageState> emit) async {
    emit(SplashPageLoadingState());
    await Future.wait([
      _initialize(),
      Future.delayed(const Duration(milliseconds: 1800))
    ]);
    emit(SplashPageLoadedState());
  }

  FutureOr<void> disposeEvent(
      DisposeEvent event, Emitter<SplashPageState> emit) {
  }

  FutureOr<void> onVideoEndEvent(
      OnVideoEndEvent event, Emitter<SplashPageState> emit) {
    emit(SplashPageLoadedState());
  }
}
