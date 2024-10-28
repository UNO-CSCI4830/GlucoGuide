import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // get current user
    final User? user = FirebaseAuth.instance.currentUser;

    final String name = user?.displayName ?? "User";

    return Row(
      children: [
        const Text('GlucoGuide', style: TextStyle(fontSize: 16)),
        const Spacer(), // Pushes the button to the right
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: const Text('Settings'),
            ),
            PopupMenuItem(
              value: 2,
              child: const Text('Other'),
            ),
          ],
          onSelected: (value) {
            // Handle the selected option
            if (value == 1) {
              Navigator.pushNamed(context, '/app_settings');
            } else if (value == 2) {
              // Do something for option 2
            } else if (value == 3) {
              // Do something for option 3
            }
          },
        ),
      ],
    );
  }
}
