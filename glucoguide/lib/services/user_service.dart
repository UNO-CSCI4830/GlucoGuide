import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glucoguide/models/user_profile.dart';

class UserService {
  // Reference to firestore singleton instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user profile for a SPECIFIC UID (per user)
  Future<UserProfile?> fetchUserProfile(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        return UserProfile.fromMap(snapshot.data()!);
      }
    } catch (e) {
      print("Error printing user profile: $e");
    }

    return null;
  }

  // Save or update a user profile with changes
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userProfile.uid)
          .set(userProfile.toMap());
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }

  // Update specific fields in a user profile
  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }
}
