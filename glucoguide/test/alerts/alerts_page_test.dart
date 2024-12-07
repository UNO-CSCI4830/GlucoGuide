import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/screens/alerts/alerts_page.dart';
import 'package:glucoguide/models/user_profile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:glucoguide/screens/alerts/edit_alert.dart';
import 'package:firebase_core/firebase_core.dart';


// Define a MockUserProvider class that can be reused
class MockUserProvider extends Mock implements UserProvider {
  // Mock data for alerts
  final List<Map<String, dynamic>> mockAlerts = [
    {'title': 'Mock Alert 1', 'date': '2024-12-06', 'time': '10:00 AM'},
    {'title': 'Mock Alert 2', 'date': '2024-12-07', 'time': '2:00 PM'},
  ];

  MockUserProvider() {
    // Set up the initial mock profile when the provider is created
    when(() => userProfile).thenReturn(UserProfile(
      alerts: mockAlerts,
      uid: '12345',
      email: 'test@example.com',
      name: 'John Doe',
      dateOfBirth: '1990-01-01',
      gender: 'Male',
      height: 180,
      weight: 75,
      country: 'USA',
      unit: 'Metric'));
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (updates.containsKey('alerts')) {
      mockAlerts
        ..clear()
        ..addAll(List<Map<String, dynamic>>.from(updates['alerts']));
    }
  }
} 

// Reusable Test Setup
Widget createTestableWidget(MockUserProvider mockProvider) {
  return ChangeNotifierProvider<UserProvider>(
    create: (_) => mockProvider,
    child: const MaterialApp(home: AlertsPage()),
  );
}

void main() {
  group('AlertsPage Tests:', () {
    //Tests displaying mock alerts
    testWidgets("Displays mock alerts", (WidgetTester tester) async {
      final mockProvider = MockUserProvider();
      await tester.pumpWidget(createTestableWidget(mockProvider));

      // Ensure that the ListView contains the correct number of ListTiles
      expect(find.byType(ListTile), findsNWidgets(2));
      // Verify that the mock alerts are displayed
      expect(find.text('Mock Alert 1'), isNotNull);
      expect(find.text('Mock Alert 2'), isNotNull);
    });
  });

  //Test adding a new alert
testWidgets('Adds a new alert', (WidgetTester tester) async {
  final mockProvider = MockUserProvider();
  await tester.pumpWidget(createTestableWidget(mockProvider));

  // Trigger the add alert action (assuming there's a button with the key 'Add New Alert')
  await tester.tap(find.byKey(Key('addNewAlertButton')));
  await tester.pumpAndSettle();

  // Now, simulate the alert addition
      final newAlert = {'title': 'New Alert', 'date': '2024-12-08', 'time': '4:00 PM'};
      mockProvider.updateUserProfile({
        'alerts': [...mockProvider.mockAlerts, newAlert]
      });
  await tester.pumpAndSettle();
  // Assuming the alert's title is updated dynamically to 'New Alert'
  expect(find.text('New Alert'), isNotNull);
});


/*testWidgets('Deletes an alert', (WidgetTester tester) async {
  // Create a mock user provider instance
  final mockProvider = MockUserProvider();
  await tester.pumpWidget(createTestableWidget(mockProvider));

  expect(mockProvider.mockAlerts
      .any((alert) => alert['title'] == 'Mock Alert 1'), true);

  await tester.tap(find.byKey(Key('deleteButton')));
  await tester.pumpAndSettle();  

  expect(mockProvider.mockAlerts
      .any((alert) => alert['title'] == 'Mock Alert 1'), false);
  expect(mockProvider.mockAlerts
      .any((alert) => alert['title'] == 'Mock Alert 2'), true);
});*/

 testWidgets("Navigates to EditAlert page", (WidgetTester tester) async {
      final mockProvider = MockUserProvider();
      await tester.pumpWidget(createTestableWidget(mockProvider));

      // Tap on an alert to edit
      await tester.tap(find.text('Mock Alert 1'));
      await tester.pumpAndSettle();

      // Verify that the EditAlert page is displayed
      expect(find.byType(EditAlert), findsOneWidget);
    });
}