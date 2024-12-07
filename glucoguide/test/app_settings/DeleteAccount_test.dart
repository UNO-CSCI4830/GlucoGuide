import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/app_settings/DeleteAccountPage.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/models/user_profile.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';

import '../mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    print("Initializing Firebase...");
    await Firebase.initializeApp();
    print("Firebase initialized.");
  });

  group("Delete Account Page Tests:", () {
    testWidgets("Mocks FirebaseAuth and verifies widgets",
        (WidgetTester tester) async {
      print("Running widget verification test...");
      await tester.pumpWidget(
        MaterialApp(
          home: DeleteAccountPage(),
        ),
      );

      print("Asserting password field...");
      expect(find.byKey(const Key('password')), findsOneWidget);
      print("Widget verification test passed.");
    });

    testWidgets("Allows text entry in password field",
        (WidgetTester tester) async {
      print("Running text entry test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const DeleteAccountPage(),
        ),
      );

      print("Entering text into password field...");
      await tester.enterText(find.byKey(const Key('password')), 'password');
      expect(find.text('password'), findsOneWidget);
    });

    testWidgets("Delete Account button exists and can be tapped",
        (WidgetTester tester) async {
      print("Running Delete Account button test...");
      await tester.pumpWidget(
        MaterialApp(
          home: const DeleteAccountPage(),
        ),
      );

      print("Finding and tapping Delete Account button...");
      final DeleteAccountButton = find.text('Delete Account');
      expect(DeleteAccountButton, findsOneWidget);
      await tester.tap(DeleteAccountButton);
      await tester.pump();
      print("Change password button test passed.");
    });
  });

  group('Confirm password deletion:', () {
    testWidgets("Testing Warning", (WidgetTester tester) async {
      print("Testing delete warning");
      await tester.pumpWidget(
        MaterialApp(
          home: const DeleteAccountPage(),
        ),
      );

      await tester.enterText(find.byKey(const Key('password')), 'password');
      final DeleteAccountButton = find.text('Delete Account');
      expect(DeleteAccountButton, findsOneWidget);
      await tester.tap(DeleteAccountButton);
      await tester.pump();
      expect(
          find.text('Warning: Deleting your account permanently'
              'deletes your information. This action cannot'
              'be undone. Select Yes to delete your account.'),
          findsOneWidget);
      print('Correct warning is displayed.');
    });

    testWidgets("Testing No button", (WidgetTester tester) async {
      print("Testing No Button");
      await tester.pumpWidget(
        MaterialApp(
          home: const DeleteAccountPage(),
        ),
      );

      await tester.enterText(find.byKey(const Key('password')), 'password');
      final DeleteAccountButton = find.text('Delete Account');
      final NoButton = find.text('No');
      expect(DeleteAccountButton, findsOneWidget);
      await tester.tap(DeleteAccountButton);
      await tester.pump();
      await tester.tap(NoButton);
      expect(NoButton, findsOneWidget);
      print('Correct button is displayed.');
    });

    testWidgets("Testing yes button", (WidgetTester tester) async {
      print("Testing delete warning");
      await tester.pumpWidget(
        MaterialApp(
          home: const DeleteAccountPage(),
        ),
      );

      await tester.enterText(find.byKey(const Key('password')), 'password');
      final DeleteAccountButton = find.text('Delete Account');
      final YesButton = find.text('Yes');
      expect(DeleteAccountButton, findsOneWidget);
      await tester.tap(DeleteAccountButton);
      await tester.pump();
      expect(YesButton, findsOneWidget);
      print('Correct button is displayed.');
    });
  });
}

class MockUserProvider extends Mock implements UserProvider {
  MockUserProvider() {
    when(() => userProfile).thenReturn(UserProfile(
      uid: '1',
      email: 'fdjk',
      name: 'j',
      dateOfBirth: '2001-06-05',
      gender: 'Male',
      height: 200,
      weight: 40,
      country: 'US',
      unit: 'kg',
    ) as UserProfile? Function());
  }
}
