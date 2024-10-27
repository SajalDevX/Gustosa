import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gustosa/entry/entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/shared/config/constants/secrets.dart';
import 'app/shared/core/inject_dependency/dependencies.dart';
import 'app/shared/core/local_storage/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: SupabaseCredentials.APIURL,
    anonKey: SupabaseCredentials.APIKEY,
  );
  await AppLocalStorage.initialize();

  await initializeDependencies();

  runApp(Entry());
}



