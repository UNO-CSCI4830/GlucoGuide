import 'package:flutter/material.dart';

class PrivacyCenterPage extends StatelessWidget {
  const PrivacyCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Center'),
      ),

      // Account Settings page
      body: Center(
        child: const Text('Privacy Center'),
      ),
    );
  }
}
