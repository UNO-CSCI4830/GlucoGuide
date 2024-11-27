//lib//pages/edit_alert.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//page to edit existing alert
class EditAlert extends StatefulWidget {
  final Map<String, dynamic> alert;
  final Function(Map<String, dynamic>) onDelete;
  final String alertID;
  const EditAlert({
    Key? key,
    required this.alert,
    required this.onDelete,
    required this.alertID,
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
    assert(widget.alertID != null && widget.alertID.isNotEmpty, "Alert ID is required");
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
 // Function to update the alert in Firebase
  Future<void> _updateAlert() async {
    try {
      // Reference to the alert document in Firestore
      final alertRef = FirebaseFirestore.instance.collection('alerts').doc(widget.alertID);

      // Update the alert in Firestore
      await alertRef.update({
        'title': alert_name.text.isNotEmpty ? alert_name.text : '',
        'date': selected_date.text.isNotEmpty ? selected_date.text : '',
        'time': selected_time.text.isNotEmpty ? selected_time.text : '',
      });

      // If successful, return the updated alert to the previous page
      final updatedAlert = {
        'title': alert_name.text,
        'date': selected_date.text,
        'time': selected_time.text,
        'id': widget.alertID, // Ensure the ID is retained
      };

      Navigator.pop(context, updatedAlert);
    } catch (e) {
      // Handle error
      print('Failed to update alert: $e');
    }
  }

 // Function to delete the alert from Firebase
  Future<void> _deleteAlert() async {
    try {
      final alertRef = FirebaseFirestore.instance.collection('alerts').doc(widget.alertID);

      // Delete the alert from Firestore
      await alertRef.delete();

      // Call the onDelete callback in the parent widget
      widget.onDelete(widget.alert);

      // Navigate back to the AlertsPage after deletion
      Navigator.pop(context);
    } catch (e) {
      print('Failed to delete alert: $e');
    }
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