//lib//pages/edit_alert.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditAlert extends StatefulWidget {
  final Map<String, dynamic> alert;
  final Function(Map<String, dynamic>) onDelete;
  final int alertIndex;
  final List<Map<String, dynamic>> alertsList; // Pass alertsList here
  final Function(List<Map<String, dynamic>>) onUpdateAlertsList; // Callback for parent state

  const EditAlert({
    Key? key,
    required this.alert,
    required this.onDelete,
    required this.alertIndex,
    required this.alertsList,
    required this.onUpdateAlertsList,
  }) : super(key: key);

  @override
  edit_alert createState() => edit_alert();
}

class edit_alert extends State<EditAlert> {
  final TextEditingController alert_name = TextEditingController();
  final TextEditingController selected_date = TextEditingController();
  final TextEditingController selected_time = TextEditingController();

  @override
  void initState() {
    super.initState();
    alert_name.text = widget.alert['title'] ?? '';
    selected_date.text = widget.alert['date'] ?? '';
    selected_time.text = widget.alert['time'] ?? '';
  }

  void dispose() {
    alert_name.dispose();
    selected_date.dispose();
    selected_time.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selected_date.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selected_time.text = picked.format(context);
    }
  }


// Function to update alert in Firestore and locally
Future<void> _updateAlert() async {
  try {
    // Get the current user's UID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User is not authenticated');
      return;
    }

    // Update the alert locally in alertsList
    final updatedAlert = {
      'title': alert_name.text,
      'date': selected_date.text,
      'time': selected_time.text,
    };

    final updatedAlertsList = List<Map<String, dynamic>>.from(widget.alertsList);
    updatedAlertsList[widget.alertIndex] = updatedAlert;

    // Update Firestore with the correct user ID
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId); // Use dynamic userId
    await userDocRef.update({'alerts': updatedAlertsList});

    // Update parent state
    widget.onUpdateAlertsList(updatedAlertsList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert updated'), duration: Duration(seconds: 2),),
      );
    // Navigate back with updated alert
    Navigator.pop(context, updatedAlert);
  } catch (e) {
    print('Failed to update alert: $e');
  }
}

  Future<void> _deleteAlert() async {
      // Call the onDelete callback (optional)
      widget.onDelete(widget.alert);
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert deleted'), duration: Duration(seconds: 2),),
      );
      // Navigate back to the AlertsPage
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Edit Alert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: alert_name,
              decoration: const InputDecoration(labelText: 'Alert Title'),
            ),
            TextField(
              controller: selected_date,
              decoration: const InputDecoration(labelText: 'Date'),
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: selected_time,
              decoration: const InputDecoration(labelText: 'Time'),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateAlert,
              child: const Text('Update Alert'),
            ),
            ElevatedButton(
              onPressed: _deleteAlert,
              child: const Text('Delete Alert'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
