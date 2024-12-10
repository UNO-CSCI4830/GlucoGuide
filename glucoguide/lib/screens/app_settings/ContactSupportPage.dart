import 'package:flutter/material.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupportPage> {
  final TextEditingController feedbackController = TextEditingController();
  final List<String> entries = [];

  void submitEntry() {
    // Send the feedback to the server
    entries.add(feedbackController.text);
    _dialogBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                submitEntry();
                feedbackController.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: const Text('Submission was Successful!'));
      });
}
