import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/pages/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'app/platforms/mobile/auth/domain/usecases/insert_user_use_case.dart';
import 'app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'app/platforms/mobile/auth/presentation/pages/auth_page.dart';
import 'app/platforms/mobile/auth/presentation/pages/signup_scren.dart';
import 'app/shared/config/constants/enums.dart';
import 'app/shared/config/constants/secrets.dart';
import 'app/shared/config/routes/routes.dart';
import 'app/shared/core/inject_dependency/dependencies.dart';
import 'app/shared/core/local_storage/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseCredentials.APIURL,
    anonKey: SupabaseCredentials.APIKEY,
  );

  // Initialize local storage
  await AppLocalStorage.initialize();

  // Initialize other dependencies
  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            sl<FetchUserUseCase>(),
            sl<UpdateUserUseCase>(),
            sl<InsertUserUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Auth Flow Example',
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => OnBoardingScreen(),
          AppRoutes.initial: (context) => AuthScreen(),
          AppRoutes.userSignUp: (context) => SignUpScreen(),
          AppRoutes.home: (context) => HomeScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus(); // Check user status on app start
  }

  Future<void> _checkUserStatus() async {
    // Simulate a delay to show the splash screen (optional)
    await Future.delayed(Duration(seconds: 2));

    // Fetch user ID and onboarding status from local storage
    final String? gustId =
        AppLocalStorage.gustId; // Get user authentication status
    final UserOnboardStatus? onboardStatus =
        AppLocalStorage.userOnboardStatus; // Get onboarding status

    // User has not authenticated yet
    if (gustId == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.initial);
    }
    // User is authenticated but not fully signed up
    else if (onboardStatus == UserOnboardStatus.signUpForm) {
      Navigator.pushReplacementNamed(context, AppRoutes.userSignUp);
    }
    // User is fully signed up
    else if (onboardStatus == UserOnboardStatus.loggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    // Default case, if nothing is found
    else {
      Navigator.pushReplacementNamed(context, AppRoutes.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Splash screen with a loader
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout logic here
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You are successfully logged in.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement any additional functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Home screen button clicked!")),
                );
              },
              child: Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle logout
  void _logout(BuildContext context) {
    // Clear the local storage and navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/user-sign-up');
    // You can also clear local data here if needed
  }
}