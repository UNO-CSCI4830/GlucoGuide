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

  // Constructor for creating a new UserProfile instance
  UserProfile(
      {required this.uid,
      required this.email,
      required this.name,
      required this.dateOfBirth,
      required this.gender,
      required this.height,
      required this.weight,
      required this.country,
      required this.unit});

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
    );
  }
}
