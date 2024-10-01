import 'dart:async';
import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:gustosa/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:gustosa/app/shared/config/constants/constants.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/config/routes/routes.dart';
import 'package:gustosa/app/shared/core/inject_dependency/dependencies.dart';
import 'package:gustosa/app/shared/core/local_storage/local_storage.dart';
import 'package:gustosa/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wiredash/wiredash.dart';

void app(Entity entity) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Supabase.initialize(
      url: const String.fromEnvironment('supabase_url'),
      anonKey: const String.fromEnvironment('supabase_anon_key'),
    );

    await AppLocalStorage.initialize();
    await initializeDependencies();

    Future.delayed(const Duration(milliseconds: 600), () {
      sl<HomePageBloc>().entity = entity;
    });

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    }

    sl<Talker>().log('APP_OPENED');

    runApp(const HushhInitial());
  }, (error, stackTrace) {
    if (!kIsWeb) {
      sl<Talker>().handle(error, stackTrace, 'Uncaught app exception');
    }
  });
}

// Widget to initialize the app
class HushhInitial extends StatefulWidget {
  const HushhInitial({Key? key}) : super(key: key);

  @override
  State<HushhInitial> createState() => _HushhInitialState();
}

class _HushhInitialState extends State<HushhInitial>
    with WidgetsBindingObserver {
  late double width;
  late double height;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    WidgetsBinding.instance.addObserver(this);

    if (AppLocalStorage.gustId != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return DevicePreview(
      enabled: !isMobile && kIsWeb,
      builder: (context) => Wiredash(
        projectId: const String.fromEnvironment('wire_dash_project_id'),
        secret: const String.fromEnvironment('wire_dash_secret'),
        child: ResponsiveSizer(
          builder: (context, orientation, screenType) => MaterialApp(
            navigatorKey: navigatorKey,
            locale: DevicePreview.locale(context),
            navigatorObservers: [
              TalkerRouteObserver(sl<Talker>()),
            ],
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.transparent,
              ),
              fontFamily: "Figtree",
            ),
            supportedLocales: const [Locale('en', 'US')],
            debugShowCheckedModeBanner: false,
            routes: NavigationManager.routes,
          ),
        ),
      ),
    );
  }
}
