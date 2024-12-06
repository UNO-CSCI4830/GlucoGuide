import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/widgets/insulin_calculator.dart';
import 'package:provider/provider.dart';

class MockUserProvider extends Mock implements UserProvider {}

//Implementing the logic from the dosecalucltor in insulin_calculator.dart
class DoseCalculator {
  static double calculate({
    required double glucose,
    required double carbs,
    double sensitivityFactor = 50.0,
    double carbRatio = 10.0,
    double targetGlucose = 100.0,
  }) {
    return ((glucose - targetGlucose) / sensitivityFactor) +
        (carbs / carbRatio);
  }
}

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

  testWidgets(
    'test that default values are set in the TextFields',
    (WidgetTester tester) async {
      await tester.pumpWidget(testWidgetSetup());

      // finding the TextFields
      final sensitivityFactorField =
          find.widgetWithText(TextField, 'Sensitivity Factor');
      final carbRatioField = find.widgetWithText(TextField, 'Carb Ratio');
      final targetGlucoseField =
          find.widgetWithText(TextField, 'Target Glucose (mg/dL)');

      // grabbing the TextField widgets to access their corresponding controllers
      final sensitivityFactorTextField =
          tester.widget<TextField>(sensitivityFactorField);
      final carbRatioTextField = tester.widget<TextField>(carbRatioField);
      final targetGlucoseTextField =
          tester.widget<TextField>(targetGlucoseField);

      // checking if the default values are correctly set in the controllers
      expect(sensitivityFactorTextField.controller?.text, '50');
      expect(carbRatioTextField.controller?.text, '10');
      expect(targetGlucoseTextField.controller?.text, '100');
    },
  );

  test('testing if DoseCalculator.calculate calculates insulin dose correctly',
      () {
    final dose = DoseCalculator.calculate(
      glucose: 100,
      carbs: 10,
      sensitivityFactor: 10,
      carbRatio: 10,
      targetGlucose: 100,
    );

    // Expected dose = ((100 - 100) / 10) + (10 / 10) = 1
    expect(dose, 1);
  });
}
