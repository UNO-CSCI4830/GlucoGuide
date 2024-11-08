class UserProfile {
  String uid;
  String email;
  String name;
  String dateOfBirth;
  String gender;
  int height;
  int weight;
  String country;
  String unit;

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
