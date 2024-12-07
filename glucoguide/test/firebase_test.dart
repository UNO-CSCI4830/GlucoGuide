import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucoguide/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('0'), findsOneWidget); // Check if the counter starts at 0
});
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase initialization tests', () {
    test('should initialize Firebase correctly', () async {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Check if Firebase has been initialized by asserting that the app is not null
      expect(Firebase.app(), isNotNull);
    });

    // You can add other tests related to Firebase initialization here
  });
}