import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),

      // Account Settings page
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('GlucoGuide',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(147, 36, 185, 156))),
        Text('Version 1.0', style: TextStyle(fontSize: 25)),
        Text('Copyright 2024, GlucoGuide. All rights reserved.',
            style: TextStyle(fontSize: 15)),
      ])),
    );
  }
}
