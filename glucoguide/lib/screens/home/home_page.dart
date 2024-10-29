import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final User? user = FirebaseAuth.instance.currentUser;

    final String name = user?.email.toString() ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Color.fromARGB(147, 36, 185, 156),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Other'),
              ),
            ],
            onSelected: (value) {

              if (value == 1) {
                Navigator.pushNamed(context, '/app_settings');
              } else if (value == 2) {

              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Welcome, $name!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
                height: 20), 
          ],
        ),
      ),
    );
  }
}
