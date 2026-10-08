import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase must be initialised before any Firebase service
  // (Auth, Firestore, Storage) is created by the service locator.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await sl.setup();

  runApp(const HasthakalaApp());
}