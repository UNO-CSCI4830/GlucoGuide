import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:glucoguide/screens/signup/register__page.dart';
import 'package:provider/provider.dart';

import '../mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    print("Initializing Firebase...");
    await Firebase.initializeApp();
    print("Firebase initialized.");
  });

  group("Login Page Tests:", () {
    testWidgets("Mocks FirebaseAuth and verifies widgets",
        (WidgetTester tester) async {
      print("Running widget verification test...");
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      print("Asserting email and password fields...");
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      print("Widget verification test passed.");
    });

    testWidgets("Navigates to Register Page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Register Page test...");
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
          routes: {
            '/register': (context) => const RegisterPage(),
          },
        ),
      );

      print("Tapping 'Go to Register' button...");
      await tester.tap(find.text('Go to Register'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Register Page...");
      expect(find.byType(RegisterPage), findsOneWidget);
      print("Navigation test passed.");
    });

    testWidgets("Allows text entry in email and password fields",
        (WidgetTester tester) async {
      print("Running text entry test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      print("Entering text into email field...");
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      print("Entering text into password field...");
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      expect(find.text('password123'), findsOneWidget);
      print("Text entry test passed.");
    });

    testWidgets("Sign-In button exists and can be tapped",
        (WidgetTester tester) async {
      print("Running Sign-In button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      print("Finding and tapping Sign-In button...");
      final signInButton = find.text('Sign In');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("Sign-In button test passed.");
    });
  });
}
