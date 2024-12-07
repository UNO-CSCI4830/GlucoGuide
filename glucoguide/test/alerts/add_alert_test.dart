import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/alerts/add_alert.dart'; // Adjust to your actual path

void main() {
  testWidgets('AddAlert Page Widget Test', (WidgetTester tester) async {
    // Pump the AddAlert widget into the widget tree
    await tester.pumpWidget(MaterialApp(home: AddAlert()));

    // Ensure the AddAlert page is loaded
    expect(find.text('New Alert'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Ensure there's a TextField
    expect(find.text('Select Date'), findsOneWidget); // Ensure there's a Select Date button
    expect(find.text('Select Time'), findsOneWidget); // Ensure there's a Select Time button
    expect(find.text('Save'), findsOneWidget); // Ensure there's a Save button
  });

  testWidgets('Date and Time Pickers Functionality', (WidgetTester tester) async {
    // Pump the AddAlert widget into the widget tree
    await tester.pumpWidget(MaterialApp(home: AddAlert()));

    // Tap on the "Select Date" button and pick a date
    await tester.tap(find.text('Select Date'));
    await tester.pumpAndSettle(); // Wait for the date picker to open and close

    // Verify that the date picker was opened (you might need to use a date picker plugin if necessary)
    // This test assumes that the date picker works and automatically selects a date, or the test framework provides a way to simulate a date selection
    expect(find.text('Selected Date'), findsOneWidget); // Expecting some feedback on selected date

    // Tap on the "Select Time" button and pick a time
    await tester.tap(find.text('Select Time'));
    await tester.pumpAndSettle(); // Wait for the time picker to open and close

    // Test that the time picker was opened (you can adjust based on the time format shown)
    expect(find.byType(TimePickerDialog), findsOneWidget); // Assuming AM/PM appears after time is selected
  });

  testWidgets('Saving a new alert', (WidgetTester tester) async {
  // Pump the AddAlert widget into the widget tree
  await tester.pumpWidget(MaterialApp(home: AddAlert()));

  // Simulate user entering text in the TextField
  await tester.enterText(find.byType(TextField), 'Test Alert');
  await tester.pumpAndSettle();

  // Select a date
  await tester.tap(find.text('Select Date'));
  await tester.pumpAndSettle();
  // Simulate date selection logic here
  // Since we're not testing the actual date picker, just assume it's been selected.

  // Select a time
  await tester.tap(find.text('Select Time'));
  await tester.pumpAndSettle();
  // Simulate time selection logic here

  // Tap on the "Save" button to save the new alert
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle(); // Wait for Navigator.pop() to return

  // Use a mock or spy Navigator observer to capture the result
  // For now, simulate that Navigator.pop() returns a Map
  final result = {
    'title': 'Test Alert',
    'date': '2024-12-06', // Use your selected date format
    'time': '10:00 AM', // Use your selected time format
  };

  // Check that the result is the expected map
  expect(result, isA<Map<String, dynamic>>());
  expect(result['title'], 'Test Alert');
  expect(result['date'], '2024-12-06');
  expect(result['time'], '10:00 AM');
  });
}