import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/main_wrapper.dart';
import 'package:glucoguide/screens/app_settings/app_settings.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:glucoguide/screens/signup/register__page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GlucoGuide",
      initialRoute: "/login",
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) =>
            const MainWrapper(), //Main Wrapper for pages with bottom navigation
        '/app_settings': (context) => const AppSettingsPage(),
      },
    );
  }
}
