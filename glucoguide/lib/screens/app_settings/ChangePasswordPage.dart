import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _status = ''; // Status message to display registration result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Changing Password')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Change Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => _confirmPasswordChange(context),
                  child: const Text('Change Password')),
              const SizedBox(height: 20),
              Text(_status),
            ],
          ),
        ));
  }

  void _confirmPasswordChange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Password Change'),
          content: Text('Are you sure you want to change your password?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print('No button pressed');
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _changePassword;
                // child:
                const Text('Button yes');
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(String code, String newPassword) async {
    // This will change the password through an email to the users account
  }
}
