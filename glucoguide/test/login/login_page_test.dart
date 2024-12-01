import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:glucoguide/screens/signup/register__page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    // Mock Firebase initialization
    await Firebase.initializeApp();
  });
  group("Login Page Tests:", () {
    testWidgets("Mocks FirebaseAuth and verifies widgets",
        (WidgetTester tester) async {
      final FirebaseAuth authService = FirebaseAuth.instance;

      // inject dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Assert widgets exist (email and pass fields)
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
    });

    testWidgets("Navigates to Register Page when button is tapped",
        (WidgetTester tester) async {
      // Inject dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
          routes: {
            '/register': (context) => const RegisterPage(),
          },
        ),
      );

      // Tap "Go to Register" button
      await tester.tap(find.text('Go to Register'));
      await tester.pumpAndSettle();

      // Verify that RegisterPage is displayed
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets("Allows text entry in email and password fields",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      // Enter text into the email field
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      // Enter text into the password field
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets("Sign-In button exists and can be tapped",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      // Find the Sign-In button
      final signInButton = find.text('Sign In');
      expect(signInButton, findsOneWidget);

      // Tap the button
      await tester.tap(signInButton);
      await tester.pump(); // Process the tap

      // Since this test doesn't check backend, it only ensures the button works
    });
  });
}
