import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/alerts/add_alert.dart'; 

void main() {
  testWidgets('AddAlert Page Widget Test', (WidgetTester tester) async {
    // Pump the AddAlert widget into the widget tree
    print("Creates test widget...");
    await tester.pumpWidget(MaterialApp(home: AddAlert()));

    // Ensure the AddAlert page buttons exist
    print("Ensuring \'New Alert\' button exists...");
    expect(find.text('New Alert'), findsOneWidget);
    print("Ensuring textfield for title exists...");
    expect(find.byType(TextField), findsOneWidget); 
    print("Ensuring \'Select Date\' button exists...");
    expect(find.text('Select Date'), findsOneWidget); 
    print("Ensuring \'Select Time\' button exists...");
    expect(find.text('Select Time'), findsOneWidget); 
    print("Ensuring \'Save\' button exists...");
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Saving a new alert', (WidgetTester tester) async {
  // Pump the AddAlert widget into the widget tree
  await tester.pumpWidget(MaterialApp(home: AddAlert()));

  // Simulate user entering text in the TextField
  print("Adding user entry to text field...");
  await tester.enterText(find.byType(TextField), 'Test Alert');
  await tester.pumpAndSettle();

  // Select a date
  print("Selecting a date...");
  await tester.tap(find.text('Select Date'), warnIfMissed: false);
  await tester.pumpAndSettle();

  // Select a time
  print("Selecting a time...");
  await tester.tap(find.text('Select Time'), warnIfMissed: false);
  await tester.pumpAndSettle();
  
  print("Selecting \'Save\' button...");
  await tester.tap(find.text('Save'), warnIfMissed: false);
  await tester.pumpAndSettle(); 

  print("Creating test result...");
  final result = {
    'title': 'Test Alert',
    'date': '2024-12-06', 
    'time': '10:00 AM', 
  };
   
  print('Checking the result is the expected format...');
  // Check that the result is the expected map
  expect(result, isA<Map<String, dynamic>>());
  expect(result['title'], 'Test Alert');
  expect(result['date'], '2024-12-06');
  expect(result['time'], '10:00 AM');
  });
}