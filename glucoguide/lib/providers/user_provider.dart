import 'package:flutter/material.dart';
import 'package:glucoguide/models/user_profile.dart';
import 'package:glucoguide/services/user_service.dart';

/// `UserProvider` manages the user profile data in the application.
/// It provides an interface to fetch, update, and clear the user profile
/// while notifying dependent widgets of any state changes.
///
/// This class works in conjunction with the `UserService` to perform
/// Firestore operations and acts as a global state manager for the user profile.

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;

  // A service to handle Firestore operations related to the user profile.
  final UserService _userService = UserService();

  // Getter to access user profile
  UserProfile? get userProfile => _userProfile;

  /// Fetches and loads a user profile from Firestore by the given [uid].
  ///
  /// This method calls the `fetchUserProfile` function from the `UserService`.
  /// Once the profile is fetched, it is stored locally in `_userProfile`,
  /// and widgets dependent on this provider are notified.
  ///
  /// - [uid]: The unique identifier for the user in Firestore.
  Future<void> loadUserProfile(String uid) async {
    try {
      _userProfile = await _userService.fetchUserProfile(uid);
      notifyListeners(); // Notify widgets that rely on this provider
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  /// Updates specific fields in the user's profile both locally and in Firestore.
  ///
  /// This method:
  /// - Updates the specified fields in Firestore using `UserService`.
  /// - Updates the `_userProfile` locally with the new field values.
  /// - Notifies widgets of the change via `notifyListeners()`.
  ///
  /// - [updates]: A map of field names and their new values.
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (_userProfile != null) {
      try {
        await _userService.updateUserProfile(_userProfile!.uid, updates);
        // Update the local state
        _userProfile = UserProfile.fromMap({
          ..._userProfile!.toMap(),
          ...updates,
        });
        notifyListeners();
      } catch (e) {
        print("Error updating user profile: $e");
      }
    }
  }

  /// Clears the loaded user profile from memory.
  ///
  /// This is typically used during logout to remove sensitive user data
  /// and notify dependent widgets of the state reset.
  void clearUserProfile() {
    _userProfile = null;
    notifyListeners();
  }
}
