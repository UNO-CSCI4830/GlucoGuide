import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/app_settings/ChangePasswordPage.dart';
import 'package:glucoguide/screens/app_settings/DeleteAccountPage.dart';
import 'package:glucoguide/screens/app_settings/PrivacyCenterPage.dart';
import 'package:glucoguide/screens/app_settings/PushNotificationPage.dart';
import 'package:glucoguide/screens/app_settings/ReminderPage.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:glucoguide/screens/app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';

import '../mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    print("Initializing Firebase...");
    await Firebase.initializeApp();
    print("Firebase initialized.");
  });

  group("App Settings Pages Exist", () {
    testWidgets("DeleteAccount exists and can be tapped",
        (WidgetTester tester) async {
      print("Running DeleteAccount button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping DeleteAccount button...");
      final signInButton = find.text('Delete Account');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("DeleteAccount ListTile test passed.");
    });

    testWidgets("ChangePassword exists and can be tapped",
        (WidgetTester tester) async {
      print("Running ChangePassword button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping ChangePassword button...");
      final signInButton = find.text('Change Password');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("ChangePassword ListTile test passed.");
    });

    testWidgets("LogOut exists and can be tapped", (WidgetTester tester) async {
      print("Running Log Out button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping EditProfile button...");
      final signInButton = find.text('Log Out');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("Log Out ListTile test passed.");
    });

    testWidgets("Reminders exists and can be tapped",
        (WidgetTester tester) async {
      print("Running Reminders button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping Reminders button...");
      final signInButton = find.text('Reminders');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("Reminders ListTile test passed.");
    });
    testWidgets("PrivacyCenter exists and can be tapped",
        (WidgetTester tester) async {
      print("Running PrivacyCenter button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping PrivacyCenter button...");
      final signInButton = find.text('Privacy Center');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("Privacy Center ListTile test passed.");
    });

    testWidgets("PushNotifications exists and can be tapped",
        (WidgetTester tester) async {
      print("Running PushNotifications button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const AppSettingsPage(),
        ),
      );

      print("Finding and tapping PushNotifications button...");
      final signInButton = find.text('Push Notifications');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      print("PushNotifications ListTile test passed.");
    });
  });

  group('Apps go to correct pages', () {
    testWidgets("Navigates to Delete Account page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Delete Account tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const DeleteAccountPage(),
          },
        ),
      );

      print("Tapping 'Delete Account' button...");
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Delete Account...");
      expect(find.byType(DeleteAccountPage), findsOneWidget);
      print("Navigation test passed.");
    });
    testWidgets("Navigates to Change Password page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Change Password tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const ChangePasswordPage(),
          },
        ),
      );

      print("Tapping 'Change Password' button...");
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Change Password...");
      expect(find.byType(ChangePasswordPage), findsOneWidget);
      print("Navigation test passed.");
    });
    testWidgets("Navigates to Log Out page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Log Out tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const LoginPage(),
          },
        ),
      );

      print("Tapping 'Log Out' button...");
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Log Out...");
      expect(find.byType(LoginPage), findsOneWidget);
      print("Navigation test passed.");
    });
    testWidgets("Navigates to Reminders page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Reminders tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const ReminderPage(),
          },
        ),
      );

      print("Tapping 'Reminders' button...");
      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Reminders...");
      expect(find.byType(ReminderPage), findsOneWidget);
      print("Navigation test passed.");
    });
    testWidgets("Navigates to Privacy Center page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Privacy Center tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const PrivacyCenterPage(),
          },
        ),
      );

      print("Tapping 'Privacy Center' button...");
      await tester.tap(find.text('Privacy Center'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Push Notification...");
      expect(find.byType(PrivacyCenterPage), findsOneWidget);
      print("Navigation test passed.");
    });
    testWidgets("Navigates to Push Notification page when button is tapped",
        (WidgetTester tester) async {
      print("Running navigation to Push Notification tests...");
      await tester.pumpWidget(
        MaterialApp(
          home: AppSettingsPage(),
          routes: {
            '/settings': (context) => const PushNotificationPage(),
          },
        ),
      );

      print("Tapping 'Push Notifications' button...");
      await tester.tap(find.text('Push Notifications'));
      await tester.pumpAndSettle();

      print("Asserting navigation to Push Notification...");
      expect(find.byType(PushNotificationPage), findsOneWidget);
      print("Navigation test passed.");
    });
  });
}
