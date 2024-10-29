import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),

      // Account Settings page
      body: Center(
        child: const Text('Delete Account'),
      ),
    );
  }
}
