//lib//pages/add_alert.dart
import 'package:flutter/material.dart';

class AddAlert extends StatefulWidget {
  const AddAlert({super.key});

  @override
  Add_Alert createState() => Add_Alert();
}

// Page to handle making new alerts
class Add_Alert extends State<AddAlert> {
  final TextEditingController _alertName = TextEditingController();
  DateTime? selectedDate; //variable to hold user selected date
  String? selectedTime;

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
      ScaffoldMessenger.of(context).showSnackBar(
        //Display message to show success
        SnackBar(
            content: Text('Selected Date'), duration: Duration(seconds: 2),),
      );
    }
  }

// Function to pick time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(
        () {
          selectedTime = pickedTime.format(context);
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        //Display message to show success
        SnackBar(
            content: Text('Selected Time'), duration: Duration(seconds: 2),),
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
              //Title of the alert
              controller: _alertName,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              //Date selector
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 8), // Space between date and time button
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  final newAlert = {
                    'title': _alertName.text,
                    'date': selectedDate!.toLocal().toString().split(' ')[0],
                    'time': selectedTime,
                  };
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar( 
                    const SnackBar(content: Text('Saved Alert'), duration: Duration(seconds: 2),),
                  );
                  Navigator.pop(context, newAlert);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
