import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glucoguide/screens/summary/summary.dart';
import 'package:flutter_charts/flutter_charts.dart';

void main() {
  group('SummaryPage Tests', () {
    final GlobalKey<SummaryPageState> summaryKey = GlobalKey<SummaryPageState>();

  testWidgets('Check if A1C goal opens', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
    await tester.tap(find.text('Set New Goal'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const Key('a1cGoalField')), findsOneWidget);
  });

    testWidgets('Check if add button taps', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      await tester.enterText(find.byKey(const Key('glucoseInputField')), '120');
      expect(find.text('120'), findsOneWidget);
      await tester.tap(find.byKey(const Key('addReadingButton')));
      await tester.pump();
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
    });

    testWidgets('Check for glucose UI test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.byKey(const Key('glucoseInputField')), findsOneWidget);
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
    });

    testWidgets('Check for glucose log UI', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage()));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byKey(const Key('addReadingButton')), findsOneWidget);
      expect(find.byKey(const Key('glucoseInputField')), findsOneWidget);
    });

    testWidgets('Chart test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('SummaryPage test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SummaryPage(key: summaryKey)));
      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Set New Goal'), findsOneWidget);
    });
  });
}
