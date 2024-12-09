import 'package:test/test.dart';
import 'package:glucoguide/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('should initialize correctly with given values', () {
      print("Init user profile");
      final user = UserProfile(
        uid: '12345',
        email: 'test@example.com',
        name: 'John Doe',
        dateOfBirth: '1990-01-01',
        gender: 'Male',
        height: 180,
        weight: 75,
        country: 'USA',
        unit: 'Metric',
      );

      print("Asserting User Profile values");
      expect(user.uid, '12345');
      expect(user.email, 'test@example.com');
      expect(user.name, 'John Doe');
      expect(user.dateOfBirth, '1990-01-01');
      expect(user.gender, 'Male');
      expect(user.height, 180);
      expect(user.weight, 75);
      expect(user.country, 'USA');
      expect(user.unit, 'Metric');
      expect(user.foodLogs, isEmpty);
      expect(user.bloodGlucoseLogs, isEmpty);
      expect(user.insulinDoseLogs, isEmpty);
      expect(user.alerts, isEmpty);
    });

    test('toMap should convert UserProfile to a Map correctly', () {
      final user = UserProfile(
        uid: '12345',
        email: 'test@example.com',
        name: 'John Doe',
        dateOfBirth: '1990-01-01',
        gender: 'Male',
        height: 180,
        weight: 75,
        country: 'USA',
        unit: 'Metric',
        foodLogs: [
          {'item': 'Apple', 'calories': 95},
        ],
      );

      print('Use toMap on userProfile instance');
      final map = user.toMap();

      print('Test if map is set up correctly');
      expect(map['uid'], '12345');
      expect(map['email'], 'test@example.com');
      expect(map['name'], 'John Doe');
      expect(map['dateOfBirth'], '1990-01-01');
      expect(map['gender'], 'Male');
      expect(map['height'], 180);
      expect(map['weight'], 75);
      expect(map['country'], 'USA');
      expect(map['unit'], 'Metric');
      expect(map['foodLogs'], [
        {'item': 'Apple', 'calories': 95}
      ]);
    });

    test('fromMap should create a UserProfile instance from a Map', () {
      print('Create a map for fromMap method');
      final map = {
        'uid': '12345',
        'email': 'test@example.com',
        'name': 'John Doe',
        'dateOfBirth': '1990-01-01',
        'gender': 'Male',
        'height': 180,
        'weight': 75,
        'country': 'USA',
        'unit': 'Metric',
        'foodLogs': [
          {'item': 'Apple', 'calories': 95},
        ],
      };

      print('From map used');
      final user = UserProfile.fromMap(map);

      print('Asserting if fromMap worked correctly');
      expect(user.uid, '12345');
      expect(user.email, 'test@example.com');
      expect(user.name, 'John Doe');
      expect(user.dateOfBirth, '1990-01-01');
      expect(user.gender, 'Male');
      expect(user.height, 180);
      expect(user.weight, 75);
      expect(user.country, 'USA');
      expect(user.unit, 'Metric');
      expect(user.foodLogs, [
        {'item': 'Apple', 'calories': 95}
      ]);
    });

    test('fromMap should handle null or missing optional fields gracefully',
        () {
      print('fromMap handles null values properly.');
      final map = {
        'uid': '12345',
        'email': 'test@example.com',
        'name': 'John Doe',
        'dateOfBirth': '1990-01-01',
        'gender': 'Male',
        'height': 180,
        'weight': 75,
        'country': 'USA',
        'unit': 'Metric',
      };

      final user = UserProfile.fromMap(map);

      expect(user.foodLogs, isEmpty);
      expect(user.bloodGlucoseLogs, isEmpty);
      expect(user.insulinDoseLogs, isEmpty);
      expect(user.alerts, isEmpty);
    });
  });
}
