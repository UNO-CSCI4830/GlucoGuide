import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final List<Map<String, dynamic>> _alerts = []; // List to store alerts

  // Function to add an alert to the list
  void _addAlert(Map<String, dynamic> alert) {
    setState(() {
      _alerts.add(alert);
    });
  }
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
              onPressed: () async {
                // Navigate to AddAlert page and wait for result
                final newAlert = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add_Alert()),
                );
                if (newAlert != null) {
                  _addAlert(newAlert); // Add new alert to the list
                }
              },
              child: const Text('Add New Alert'),
            ),
            const SizedBox(height: 20),
            // Display the alerts
            Expanded(
              child: ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return ListTile(
                    title: Text(alert['title']),
                    subtitle: Text('Date: ${alert['date']}, Time: ${alert['time']}'),
                  );
                },
              ),
            ),
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
  DateTime? selectedDate; //variable to hold user selected date

  //Function to pick date
  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    selectedDate = picked; //Store the selected date
    ScaffoldMessenger.of(context).showSnackBar( //Display message to show success
        SnackBar(content: Text('Selected Date: ${picked.toLocal()}'.split(' ')[0])),
    );
  }
}

// Function to pick time
  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null && selectedDate != null) { //verifies both date and time are picked
      final String formattedTime = pickedTime.format(context);
      final Map<String, dynamic> alertData = {
        'title': _alertName.text,
        'date': selectedDate!.toLocal().toString().split(' ')[0], // Format the date
        'time': formattedTime,
      };

      Navigator.pop(context, alertData); // Return the alert data to the previous page
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
            TextField( //Title of the alert
              controller: _alertName,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16), 
            ElevatedButton( //Date selector
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 8), // Space between date and time button
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select Time'),
            ),
          ],
        ),
      ),
    );
  }
}