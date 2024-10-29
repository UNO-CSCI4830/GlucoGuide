import 'package:flutter/material.dart';

class PushNotificationPage extends StatelessWidget {
  const PushNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification'),
      ),

      // Account Settings page
      body: Center(
        child: const Text('Push Notification'),
      ),
    );
  }
}
