import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glucoguide/models/user_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _countryController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedGender;
  String? _selectedUnit;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, "Full Name"),
              _buildTextField(
                  _emailController, "Email", TextInputType.emailAddress),
              _buildTextField(_passwordController, "Password"),
              GestureDetector(
                onTap: _pickDateOfBirth,
                child: AbsorbPointer(
                  child: _buildTextField(
                      _dateOfBirthController, "Date of Birth (YYYY-MM-DD)"),
                ),
              ),
              _buildDropdownField("Gender", ["Male", "Female", "Other"],
                  (value) => setState(() => _selectedGender = value)),
              _buildDropdownField("Weight Unit", ["kg", "lbs"],
                  (value) => setState(() => _selectedUnit = value)),
              _buildTextField(
                  _heightController, "Height (cm)", TextInputType.number),
              _buildTextField(
                  _weightController, "Weight", TextInputType.number),
              _buildTextField(_countryController, "Country"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
              Text(_status,
                  style: TextStyle(
                      color: _status.contains("Error")
                          ? Colors.red
                          : Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text,
      bool obscureText = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _pickDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
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
        name: _nameController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
        gender: _selectedGender ?? '',
        height: int.parse(_heightController.text.trim()),
        weight: int.parse(_weightController.text.trim()),
        country: _countryController.text.trim(),
        unit: _selectedUnit ?? '',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userProfile.toMap());

      setState(() {
        _status = 'Registered as: ${userCredential.user?.email}';
      });
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _status = 'Registration Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _dateOfBirthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
