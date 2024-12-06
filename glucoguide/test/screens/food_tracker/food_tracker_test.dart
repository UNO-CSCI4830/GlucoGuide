import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/widgets/insulin_calculator.dart';
import 'package:glucoguide/screens/food_tracker/food_tracker.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('testing if FoodTrackerPage runs correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const FoodTrackerPage()));

    // Check if the AppBar is displayed with the correct title
    expect(find.text('Tracking'), findsOneWidget);

    // Check if the InsulinDoseCalculator widget is present
    expect(find.byType(InsulinDoseCalculator), findsOneWidget);
  });
}
