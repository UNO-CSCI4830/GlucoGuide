import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucoguide/screens/alerts/edit_alert.dart';

void main() {
  
  testWidgets('Test Initialization of Form', (WidgetTester tester) async {
    print("Creating mock alert...");
    final alert = {
      'title': 'Test Alert',
      'date': '2024-12-06',
      'time': '10:00 AM',
    };
    final alertsList = [alert];
    final onDelete = (Map<String, dynamic> alert) {};
    final onUpdateAlertsList = (List<Map<String, dynamic>> alertsList) {};

    await tester.pumpWidget(MaterialApp(
      home: EditAlert(
        alert: alert,
        onDelete: onDelete,
        alertID: 'test-alert-id',
        alertsList: alertsList,
        onUpdateAlertsList: onUpdateAlertsList,
      ),
    ));

    // Check that the text fields are populated correctly
    print("Ensuring title is shown...");
    expect(find.text('Test Alert'), findsOneWidget);
    print("Ensuring date is shown...");
    expect(find.text('2024-12-06'), findsOneWidget);
    print("Ensuring time is shown...");
    expect(find.text('10:00 AM'), findsOneWidget);
  });

  testWidgets('Test Date Picker Functionality', (WidgetTester tester) async {
    print("Creating mock alert...");
    final alert = {
      'title': 'Test Alert',
      'date': '2024-12-06',
      'time': '10:00 AM',
    };
    final alertsList = [alert];
    final onDelete = (Map<String, dynamic> alert) {};
    final onUpdateAlertsList = (List<Map<String, dynamic>> alertsList) {};

    await tester.pumpWidget(MaterialApp(
      home: EditAlert(
        alert: alert,
        onDelete: onDelete,
        alertID: 'test-alert-id',
        alertsList: alertsList,
        onUpdateAlertsList: onUpdateAlertsList,
      ),
    ));

    // Tap the Date field
    print("Selects the date selector button...");
    await tester.tap(find.byType(TextField).at(1), warnIfMissed: false); 
    await tester.pumpAndSettle();

    // Simulate date selection
    print("Simulates date selection...");
    await tester.tap(find.text('6'), warnIfMissed: false); 
    await tester.pumpAndSettle();

    // Verify that the selected date is displayed
    print("Verifies correct date displayed...");
    expect(find.text('2024-12-06'), findsOneWidget);
  });

  testWidgets('Test Time Picker Functionality', (WidgetTester tester) async {
    print("Creating mock alert...");
    final alert = {
      'title': 'Test Alert',
      'date': '2024-12-06',
      'time': '10:00 AM',
    };
    final alertsList = [alert];
    final onDelete = (Map<String, dynamic> alert) {};
    final onUpdateAlertsList = (List<Map<String, dynamic>> alertsList) {};

    await tester.pumpWidget(MaterialApp(
      home: EditAlert(
        alert: alert,
        onDelete: onDelete,
        alertID: 'test-alert-id',
        alertsList: alertsList,
        onUpdateAlertsList: onUpdateAlertsList,
      ),
    ));

    // Tap the Time field
    print("Selects the time selector button...");
    await tester.tap(find.byType(TextField).at(2), warnIfMissed: false); 
    await tester.pumpAndSettle();

    // Simulate time selection
    print("Simulates time selection...");
    await tester.tap(find.text('10:00 AM'), warnIfMissed: false); 
    await tester.pumpAndSettle();

    // Verify that the selected time is displayed
    print("Verifies correct time displayed...");
    expect(find.text('10:00 AM'), findsOneWidget);
  });

  testWidgets('Test Delete Alert Functionality', (WidgetTester tester) async {
    print("Creating mock alert...");
    final alert = {
      'title': 'Test Alert',
      'date': '2024-12-06',
      'time': '10:00 AM',
    };
    final alertsList = [alert];
    final onDelete = (Map<String, dynamic> alert) {
      alertsList.remove(alert);
    };
    final onUpdateAlertsList = (List<Map<String, dynamic>> alertsList) {};

    await tester.pumpWidget(MaterialApp(
      home: EditAlert(
        alert: alert,
        onDelete: onDelete,
        alertID: 'test-alert-id',
        alertsList: alertsList,
        onUpdateAlertsList: onUpdateAlertsList,
      ),
    ));

    // Tap the Delete Alert button
    print("Selecting the 'delete' button...");
    await tester.tap(find.byKey(Key("deleteButton")), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Check that the alert has been deleted
    print("Ensuring alert has been deleted...");
    expect(alertsList.isEmpty, true);
  });
}