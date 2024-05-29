import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:foodbuds0_1/firebase_options.dart";
import "package:foodbuds0_1/ui/home_screens/home_screen.dart";
import "package:foodbuds0_1/ui/home_screens/match_screen.dart";
import "package:get/get.dart";
import "ui/authentication_screen/authentication_screen.dart";
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.playIntegrity,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodbuD',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
