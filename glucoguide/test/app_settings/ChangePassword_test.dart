import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/app_settings/ChangePasswordPage.dart';
import 'package:firebase_core/firebase_core.dart';

import '../mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    print("Initializing Firebase...");
    await Firebase.initializeApp();
    print("Firebase initialized.");
  });

  group("Change Password Page Tests:", () {
    testWidgets("Mocks FirebaseAuth and verifies widgets",
        (WidgetTester tester) async {
      print("Running widget verification test...");
      await tester.pumpWidget(
        MaterialApp(
          home: ChangePasswordPage(),
        ),
      );

      print("Asserting email field...");
      expect(find.byKey(const Key('email')), findsOneWidget);
      print("Widget verification test passed.");
    });

    testWidgets("Allows text entry in email field",
        (WidgetTester tester) async {
      print("Running text entry test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const ChangePasswordPage(),
        ),
      );

      print("Entering text into email field...");
      await tester.enterText(
          find.byKey(const Key('email')), 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets("Change Password button exists and can be tapped",
        (WidgetTester tester) async {
      print("Running Change Password button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const ChangePasswordPage(),
        ),
      );

      print("Finding and tapping Change Password button...");
      final ChangePasswordButton = find.text('Change Password');
      expect(ChangePasswordButton, findsOneWidget);
      await tester.tap(ChangePasswordButton);
      await tester.pump();
      print("Change password button test passed.");
    });
  });
  group("Change Password Invalid Input Tests:", () {
    testWidgets("Null input test", (WidgetTester tester) async {
      print("Running wrong input test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const ChangePasswordPage(),
        ),
      );

      print("Submitting nothing to change password...");
      await tester.enterText(find.byKey(const Key('email')), '');
      final ChangePasswordButton = find.text('Change Password');
      expect(ChangePasswordButton, findsOneWidget);
      await tester.tap(ChangePasswordButton);
      await tester.pump();
      expect(find.text('Please enter your email.'), findsOneWidget);
      print('Correct output occured for null.');
    });

    testWidgets("Wrong input test", (WidgetTester tester) async {
      print("Running wrong input test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const ChangePasswordPage(),
        ),
      );

      print("Submitting the wrong email to change password...");
      await tester.enterText(
          find.byKey(const Key('email')), 'wrongemail@gmail.com');
      final ChangePasswordButton = find.text('Change Password');
      expect(ChangePasswordButton, findsOneWidget);
      await tester.tap(ChangePasswordButton);
      await tester.pump();
      expect(find.text('That is not your email. Please try again.'),
          findsOneWidget);
      print('Correct output occured for wrong password');
    });
  });
}
