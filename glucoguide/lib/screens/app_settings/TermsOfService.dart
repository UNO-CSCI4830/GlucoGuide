import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            // Future terms of service
            'When the app is fully operational the Terms of Service will be here for the user to read.',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
