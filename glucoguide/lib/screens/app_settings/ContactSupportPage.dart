import 'package:flutter/material.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupportPage> {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Contact Support')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please enter your feedback"),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: "Feedback"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _submissionPopup(context);
                  },
                  child: const Text('Submit')),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  void _submissionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text('Your feedback was submitted.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                feedbackController.clear();
                Navigator.pop(context2);
              },
            ),
          ],
        );
      },
    );
  }
}
