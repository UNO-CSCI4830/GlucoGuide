import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/main_wrapper.dart';
import 'package:glucoguide/models/user_profile.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: const Text('Gluco Guide Login'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: const Key('emailField'),
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              key: const Key('passwordField'),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('signInButton'),
              onPressed: _signInUser,
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Go to Register'),
            ),
            const SizedBox(height: 20),
            Text(_status), // Display authentication status
          ],
        ),
      ),
    );
  }

  Future<void> _signInUser() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Load the user profile into the provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserProfile(userCredential.user!.uid);

      // Navigate to MainWrapper
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    } catch (e) {
      setState(() {
        _status = 'Sign-In Error: $e';
      });
    }
  }
}
