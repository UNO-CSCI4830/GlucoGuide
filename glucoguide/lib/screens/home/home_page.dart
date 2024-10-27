import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // get current user
    final User? user = FirebaseAuth.instance.currentUser;

    final String name = user?.displayName ?? "User";

    return Center(
      child: const Text(
        "Welcome to GlucoGuide",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
