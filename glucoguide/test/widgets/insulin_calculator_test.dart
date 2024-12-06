import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/widgets/insulin_calculator.dart';
import 'package:provider/provider.dart';

class MockUserProvider extends Mock implements UserProvider {}

Widget testWidgetSetup() {
  return ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
    child: MaterialApp(
      home: Scaffold(
        body: InsulinDoseCalculator(),
      ),
    ),
  );
}

void main() {
  testWidgets('testing if update button enables', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetSetup());

    final glucoseField =
        find.widgetWithText(TextField, 'Blood Glucose (mg/dL)');
    final carbsField = find.widgetWithText(TextField, 'Carbs (g)');
    final calculateButton =
        find.widgetWithText(ElevatedButton, 'Calculate Dose');

    // Button is initally disabled
    expect(tester.widget<ElevatedButton>(calculateButton).onPressed, isNull);

    // Enter a glucose value
    await tester.enterText(glucoseField, '100');
    await tester.pump();
    expect(tester.widget<ElevatedButton>(calculateButton).onPressed, isNull);

    // Entering a carb value
    await tester.enterText(carbsField, '100');
    await tester.pump();
    expect(tester.widget<ElevatedButton>(calculateButton).onPressed, isNotNull);
  });

  testWidgets(
      'testing if entering values in TextFields updates TextEditingControllers',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetSetup());

    //finding the glucose TextField
    final glucoseField =
        find.widgetWithText(TextField, 'Blood Glucose (mg/dL)');
    //"entering" 100 into the glucose TextField
    await tester.enterText(glucoseField, '100');
    await tester.pump();

    //finding the carbs TextField
    final carbsField = find.widgetWithText(TextField, 'Carbs (g)');
    //"entering" 100 into the carbs TextField
    await tester.enterText(carbsField, '100');
    await tester.pump();

    //verifying the values
    expect(tester.widget<TextField>(glucoseField).controller?.text, '100');
    expect(tester.widget<TextField>(carbsField).controller?.text, '100');
  });
}