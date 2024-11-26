import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String inputValue = '';

  String popUpBox(String title, String text, String uid) {
    final User? user = _auth.currentUser;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Change'),
          content: TextField(
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                text = inputValue;
                setState(() {});
                if (title == 'User Name') {
                  updateUserName(user, inputValue);
                  Navigator.of(context).pop();
                }
                if (title == 'Height') {
                  updateHeight(user, inputValue);
                  Navigator.of(context).pop();
                }

                if (title == 'Country') {
                  updateCountry(user, inputValue);
                  Navigator.of(context).pop();
                }
                if (title == 'Weight') {
                  updateWeight(user, inputValue);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
    return inputValue;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;
    final User? user = _auth.currentUser;

    final List<EditProfileItems> settings = [
      EditProfileItems(
          title: 'User Name', fieldName: 'name', text: userProfile!.name),
      EditProfileItems(title: 'Profile Photo', text: '', icon: Icons.person),
      EditProfileItems(
          title: 'Height',
          fieldName: 'height',
          text: (userProfile.height).toString() + ' cm'),
      EditProfileItems(
          title: 'Sex', fieldName: 'gender', text: userProfile.gender),
      EditProfileItems(
          title: 'Date of Birth',
          fieldName: 'dateOfBirth',
          text: userProfile.dateOfBirth),
      EditProfileItems(
          title: 'Country', fieldName: 'country', text: userProfile.country),
      EditProfileItems(
          title: 'Units', fieldName: 'unit', text: userProfile.unit),
      EditProfileItems(
          title: 'Weight',
          fieldName: 'weight',
          text: (userProfile.weight).toString()),
    ];
    return Card(
        child: StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(userProfile.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle errors
        } else if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          if (!data.exists) {
            return Text('User data not found'); // Handle user not found
          }
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  final setting = settings[index];
                  return ListTile(
                      title: Text(setting.title),
                      subtitle: Text(setting.text),
                      trailing: Icon(setting.icon),
                      onTap: () async {
                        if (setting.fieldName == 'gender') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select your gender'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('Male'),
                                      onTap: () {
                                        updateUserGender(user, 'Male');
                                        setting.text = 'Male';
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Female'),
                                      onTap: () {
                                        updateUserGender(user, 'Female');
                                        setting.text = 'Female';
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Other'),
                                      onTap: () {
                                        updateUserGender(user, 'Other');
                                        setting.text = 'Other';
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (setting.fieldName == 'unit') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Units'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('lbs'),
                                      onTap: () {
                                        updateUserUnits(user, 'lbs');
                                        setting.text = 'lbs';
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('kg'),
                                      onTap: () {
                                        updateUserUnits(user, 'kg');
                                        setting.text = 'kg';
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (setting.fieldName == 'dateOfBirth') {
                        } else {
                          popUpBox(
                              setting.title, setting.text, userProfile.uid);
                        }
                        setting.text =
                            inputValue; // Change to update setting.text in real time
                      });
                }));
      },
    ));
  }

  Future updateUserName(User? user, String newUsername) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'name': newUsername,
    });
  }

  Future updateHeight(User? user, String newHeight) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'height': newHeight,
    });
  }

  Future updateCountry(User? user, String newCountry) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'country': newCountry,
    });
  }

  Future updateWeight(User? user, String newWeight) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'weight': newWeight,
    });
  }

  Future updateUserGender(User? user, String newGender) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'gender': newGender,
    });
  }

  Future updateUserUnits(User? user, String newUnit) async {
    await _firestore.collection('users').doc(user?.uid).update({
      'unit': newUnit,
    });
  }
}

class EditProfileItems {
  final String title;
  final String? fieldName;
  final IconData? icon;
  String text;

  EditProfileItems({
    required this.title,
    this.fieldName,
    this.icon,
    required this.text,
  });
}
