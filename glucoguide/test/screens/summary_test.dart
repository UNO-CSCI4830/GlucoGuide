import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/summary/summary.dart';
import 'package:flutter_charts/flutter_charts.dart';

void main() {
  group('SummaryPage Tests', () {
    final GlobalKey<SummaryPageState> summaryKey = GlobalKey<SummaryPageState>();

// This will as the title says check for the A1c by clicking and test functionality
  testWidgets('Check if A1C goal opens', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
    await tester.tap(find.text('Set New Goal'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const Key('a1cGoalField')), findsOneWidget);
  });

// This will make sure that the button is clickable
    testWidgets('Check if add button taps', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      await tester.enterText(find.byKey(const Key('glucoseInputField')), '120');
      expect(find.text('120'), findsOneWidget);
      await tester.tap(find.byKey(const Key('addReadingButton')));
      await tester.pump();
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
    });

// This will make sure that input and the add reading button is there
    testWidgets('Check for glucose UI test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.byKey(const Key('glucoseInputField')), findsOneWidget);
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
    });

// This will make sure that the log list for glucose appears or is there
    testWidgets('Check for glucose log UI', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage()));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
      expect(find.byKey(const Key('glucoseInputField')), findsOneWidget);
    });

// This will make sure that the graph actually appears correctly
    testWidgets('Chart test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.byType(LineChart), findsOneWidget);
    });

// This will simply make sure that the summary page has the summary and the new goal
    testWidgets('SummaryPage test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Set New Goal'), findsOneWidget);
    });
  });
}
