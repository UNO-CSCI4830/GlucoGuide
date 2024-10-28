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

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Display the selected date using a dialog or Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected Date: ${picked.toLocal()}'.split(' ')[0])),
      );
    }
  }
  
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
            ),
            const SizedBox(height: 16), // Space between input and button
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}