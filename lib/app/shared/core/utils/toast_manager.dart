import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../local_storage/local_storage.dart';





class CustomNotification {
  final String title;
  final String? description;
  final String? route;
  final bool sendOnDeviceNotification;
  final bool storeNotification;
  DateTime? dateTime;
  ToastificationType? type;
  String? userId;

  CustomNotification({
    required this.title,
    this.userId,
    this.description,
    this.route,
    this.sendOnDeviceNotification = false,
    this.dateTime,
    this.type,
    this.storeNotification = true,
  }) {
    dateTime ??= DateTime.now();
    userId ??= AppLocalStorage.gustId;
  }

  factory CustomNotification.fromJson(Map<String, dynamic> json) {
    return CustomNotification(
      title: json['title'],
      description: json['description'],
      route: json['route'],
      type: {
        'success': ToastificationType.success,
        'info': ToastificationType.info,
        'error': ToastificationType.error,
        'warning': ToastificationType.warning,
      }[json['type']],
      dateTime: DateTime.parse(json['date_time']),
    );
  }

  Map<String, dynamic> toJson(ToastificationType type) => {
        'title': title,
        'description': description,
        'route': route,
        'date_time': dateTime?.toIso8601String(),
        'type': type.name,
        'user_id': userId,
      };
}

class Toast {
  final String? title;
  final String? description;
  final CustomNotification? notification;
  final bool showProgress;
  final Duration duration;
  final ToastificationType type;

  Toast(
      {this.title,
      this.description,
      this.notification,
      this.showProgress = true,
      this.duration = const Duration(seconds: 3),
      this.type = ToastificationType.info});
}

class ToastManager {
  final Toast toast;

  ToastManager(this.toast);

  Future<void> _sendNotification() async {}



  void show(BuildContext context, {Alignment? alignment}) {
    if (toast.notification != null) {

      if (toast.notification?.sendOnDeviceNotification == true) {
        _sendNotification();
      }
    }
    if (toast.title != null) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: toast.duration,
        title: Text(toast.title!),
        description: Text(toast.description!),
        icon: toast.type == ToastificationType.error
            ? const Icon(Icons.error, color: Colors.red)
            : toast.type == ToastificationType.warning
                ? const Icon(Icons.warning, color: Colors.orangeAccent)
                : toast.type == ToastificationType.info
            ? const Icon(Icons.info_outline, color: Colors.grey): null,
        alignment: alignment ?? Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
        showProgressBar: toast.showProgress,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: false,
        pauseOnHover: true,
        dragToClose: true,
      );
    }
  }
}
