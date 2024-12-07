import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _status = ''; // Status message to display registration result
  String emailValue = '';

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
                  key: const Key("email"),
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: "Enter your email"),
                  obscureText: true,
                  onChanged: (value) {
                    emailValue = value;
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                  key: const Key('ChangePasswordButton'),
                  onPressed: () => _testEmail(context, emailValue),
                  child: const Text('Change Password')),
              const SizedBox(height: 20),
              Text(_status),
            ],
          ),
        ));
  }

  void _testEmail(BuildContext context, String userEntry) {
    final User? user = _auth.currentUser;
    final String? trueEmail = user?.email;
    if (userEntry == trueEmail) {
      _confirmPasswordChange(context, userEntry);
    } else if (userEntry == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please enter your email.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('That is not your email. Please try again.'),
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

  void _confirmPasswordChange(BuildContext context, String userEntry) {
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
                _changePassword(userEntry);
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
            title: Text('Password reset send to email.'),
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
