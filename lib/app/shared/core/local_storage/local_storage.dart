import 'package:gustosa/app/platforms/mobile/auth/domain/entities/user_entity.dart';
import 'package:hive_flutter/adapters.dart';

import '../../config/constants/enums.dart';
import '../backend_controller/auth_controller/auth_controller_impl.dart';
import '../inject_dependency/dependencies.dart';

class Boxes {
  static const String user = 'user_data';
  static const String agent = 'agent_data';
  static const String other = 'other';
}

class AppLocalStorage {
  static final boxes = <String>[
    Boxes.user,
    Boxes.agent,
    Boxes.other,
  ];

  static Future<void> refresh() async {
    await sl<AuthController>().signOut();
    for (String box in boxes) {
      await Hive.deleteBoxFromDisk(box);
    }
    for (int i = 0; i < boxes.length; i++) {
      await Hive.openBox(
        boxes[i],
      );
    }
  }

  static void _register() {
    Hive.registerAdapter(UserOnboardStatusAdapter());
    Hive.registerAdapter(OnboardStatusAdapter());
    Hive.registerAdapter(UserEntityAdapter());
    Hive.registerAdapter(EntityAdapter());
    Hive.registerAdapter(AgentApprovalStatusAdapter());
  }

  static Future<void> initialize() async {
    await Hive.initFlutter();
    _register();
    for (int i = 0; i < boxes.length; i++) {
      await Hive.openBox(boxes[i]);
    }
  }

  static UserEntity? get user => Hive.box(Boxes.user).get('value');

  static String? get gustId => Hive.box(Boxes.other).get('gust_id');

  static UserOnboardStatus get userOnboardStatus =>
      Hive.box(Boxes.other).get('user_onboard_status') ??
      UserOnboardStatus.initial;

  static bool get isUserLoggedIn =>
      user != null && userOnboardStatus == UserOnboardStatus.loggedIn;

  static void updateGustId(String uid) {
    Hive.box(Boxes.other).put('gust_id', uid);
  }

  static void updateUserOnboardingStatus(UserOnboardStatus status) {
    Hive.box(Boxes.other).put('user_onboard_status', status);
  }

  static void updateUser(UserEntity user) {
    Hive.box(Boxes.user).put('value', user);
  }
  static Future<void> logout() async {
    await refresh();
  }
}
