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

  // Function to update an alert in the list
  void _updateAlert(int index, Map<String, dynamic> updatedAlert) {
    setState(() {
      _alerts[index] = updatedAlert;
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
                  MaterialPageRoute(builder: (context) => AddAlert()),
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
                    onTap: () async{
                      //Navigate to edit_alert page and wait for input
                      final updated_alert = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAlert(alert: alert),
                         ),
                      );
                      if(updated_alert != null){
                        _updateAlert(index, updated_alert);
                      }
                    }
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

class AddAlert extends StatefulWidget{
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
  if(pickedTime != null){
    setState((){
      selectedTime = pickedTime.format(context);
    },
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){
                if(selectedDate != null && selectedTime != null){
                  final newAlert = {
                    'title': _alertName.text,
                    'date': selectedDate!.toLocal().toString().split(' ')[0],
                    'time': selectedTime,
                  };
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

//page to edit existing alert
class EditAlert extends StatefulWidget{
  final Map<String, dynamic> alert;
  const EditAlert({required this.alert, super.key});

  @override
  edit_alert createState() => edit_alert();

}

class edit_alert extends State<EditAlert>{
  late TextEditingController alert_name;
  DateTime? selected_date;
  String? selected_time;

  @override
  void initState(){
    super.initState();
    alert_name = TextEditingController(text: widget.alert['title']);
    selected_date = DateTime.parse(widget.alert['date']);
    selected_time = widget.alert['time'];
  }

   //Function to pick date
  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selected_date ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    setState((){
      selected_date = picked; //Store the selected date
    });
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
  if (pickedTime != null) { 
      setState((){
        selected_time = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Alert')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: alert_name,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedAlert = {
                  'title': alert_name.text,
                  'date': selected_date!.toLocal().toString().split(' ')[0],
                  'time': selected_time,
                };
                Navigator.pop(context, updatedAlert);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}