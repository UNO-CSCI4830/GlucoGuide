import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/models/user_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  String? _selectedGender;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _status = ''; // Status message to display registration result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Regsiter GlucoGuide Account')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Create Password"),
                obscureText: true,
              ),
              TextField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(
                    labelText: "Date of Birth (MON-DD-YYYY)"),
              ),
              DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(labelText: "Gender"),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  }),

              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _registerUser, child: const Text('Register')),
              const SizedBox(height: 20),

              // Display status of registration
              Text(_status),
            ],
          ),
        ));
  }

  Future<void> _registerUser() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userProfile = UserProfile(
          uid: userCredential.user!.uid,
          email: _emailController.text.trim(),
          name: '',
          dateOfBirth: _dateOfBirthController.text.trim(),
          gender: '',
          height: 5,
          weight: 5,
          country: '',
          unit: '');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userProfile.toMap());

      setState(() {
        _status = 'Registered as: ${userCredential.user?.email}';
      });
      Navigator.pushReplacementNamed(context, '/login'); // Go to home page
    } catch (e) {
      setState(() {
        _status = 'Registration Error: $e';
      });
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers to free resources
    _emailController.dispose();
    _passwordController.dispose();
    // _nameController.dispose();
    _dateOfBirthController.dispose();
    // _heightController.dispose();
    // _weightController.dispose();
    // _countryController.dispose();
    super.dispose();
  }
}
