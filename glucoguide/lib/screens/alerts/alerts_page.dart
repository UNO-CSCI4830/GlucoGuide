import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Page1
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add_Alert()),
                );
              },
              child: const Text('Add New Alert'),
            )
          ],
        ),
      ),
    );
  }
}

// Page to handle making new alerts
class Add_Alert extends StatelessWidget {
  Add_Alert({super.key});
  final _alertName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Alert')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _alertName,
              decoration: const InputDecoration(labelText: 'Title'),
            )
          ],
        ),
      ),
    );
  }
}