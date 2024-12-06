import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _emailController = TextEditingController();

  String _status = ''; // Status message to display registration result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Password Change')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: "Enter your email"),
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
                _changePassword(_emailController.text.trim());
                const Text('Button yes');
                Navigator.of(context).pop();
                _emailController.clear();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset send to email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print('Error sending email');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error sending reset email'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
