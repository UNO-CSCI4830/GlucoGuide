class UserProfile {
  // Basic user information fields
  String uid;
  String email;
  String name;
  String dateOfBirth;
  String gender;
  int height;
  int weight;
  String country;
  String unit;

  // Logs (food, blood glucose and insulin doses)
  // Stored in a LIST of key value pairs
  List<Map<String, dynamic>> foodLogs = [];
  List<Map<String, dynamic>> bloodGlucoseLogs = [];
  List<Map<String, dynamic>> insulinDoseLogs = [];
  List<Map<String, dynamic>> alerts = [];

  // Constructor for creating a new UserProfile instance
  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.country,
    required this.unit,
    this.foodLogs = const [],
    this.bloodGlucoseLogs = const [],
    this.insulinDoseLogs = const [],
    this.alerts = const [],
  });

  // Converts the UserProfile instance into a Map
  // This is useful for saving data to Firestore or other databases
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'country': country,
      'unit': unit,
      'foodLogs': foodLogs,
      'bloodGlucoseLogs': bloodGlucoseLogs,
      'insulinDoseLogs': insulinDoseLogs,
      'alerts': alerts
    };
  }

  // Factory constructor to create a UserProfile instance from a Map
  // This is useful for retrieving data from Firestore or other databases
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        dateOfBirth: map['dateOfBirth'],
        gender: map['gender'],
        height: map['height'],
        weight: map['weight'],
        country: map['country'],
        unit: map['unit'],
        foodLogs: List<Map<String, dynamic>>.from(map['foodLogs'] ?? []),
        bloodGlucoseLogs:
            List<Map<String, dynamic>>.from(map['bloodGlucoseLogs'] ?? []),
        insulinDoseLogs:
            List<Map<String, dynamic>>.from(map['insulinDoseLogs'] ?? []),
        alerts: List<Map<String, dynamic>>.from(map['alerts'] ?? []));
  }
}
