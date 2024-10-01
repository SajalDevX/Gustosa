import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../platforms/mobile/auth/domain/entities/agent_model.dart';
import '../../../platforms/mobile/auth/domain/entities/user_model.dart';
import '../backend_controller/auth_controller/auth_controller_impl.dart';
import '../inject_dependency/dependencies.dart';

class Boxes{
  static const String user = 'user_data';
  static  const String agent = 'agent_data';
  static const String other = 'other';
}
class AppLocalStorage{
  static final boxes = <String>[
    Boxes.user,
    Boxes.agent,
    Boxes.other
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
    Hive.registerAdapter(AgentModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(UserOnboardStatusAdapter());
    Hive.registerAdapter(OnboardStatusAdapter());
    Hive.registerAdapter(AgentApprovalStatusAdapter());
    Hive.registerAdapter(EntityAdapter());
  }
  static Future<void> initialize() async{
    await Hive.initFlutter();
    _register();
    for(int i=0;i<boxes.length;i++){
      await Hive.openBox(boxes[i]);
    }
  }
  static UserModel? get user => Hive.box(Boxes.user).get('value');

  static AgentModel? get agent => Hive.box(Boxes.agent).get('value');
  static String? get gustId => Hive.box(Boxes.other).get('gust_id');
  static UserOnboardStatus get userOnboardStatus =>
      Hive.box(Boxes.other).get('user_onboard_status') ??
          UserOnboardStatus.initial;

  static void updateGustId(String uid) {
    Hive.box(Boxes.other).put('gust_id', uid);
  }
  static void updateUser(UserModel user) {
    Hive.box(Boxes.user).put('value', user);
  }

  static void updateAgent(AgentModel agent) {
    Hive.box(Boxes.agent).put('value', agent);
  }

  static Future<void> logout() async {
    await refresh();
  }
  static void updateUserOnboardingStatus(UserOnboardStatus status) {
    Hive.box(Boxes.other).put('user_onboard_status', status);
  }
  static bool get isUserLoggedIn =>
      user != null && userOnboardStatus == UserOnboardStatus.loggedIn;
}