import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'add_alert.dart';
import 'edit_alert.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final List<Map<String, dynamic>> _alerts = []; // List to store alerts

  //Function to delete an alert
  void _deleteAlert(Map<String, dynamic> alert){
    setState((){
      _alerts.remove(alert);
    });
  }
  // Function to add an alert to the list
  void _addAlert(Map<String, dynamic> alert) {
    setState(() {
      _alerts.add(alert);
    });

    // instantiate user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final currentAlerts =
        List<Map<String, dynamic>>.from(userProvider.userProfile?.alerts ?? []);
    currentAlerts.add(alert);

    // update userProfile
    userProvider.updateUserProfile({'alerts': currentAlerts});
  }

  // Function to update an alert in the list
  void _updateAlert(int index, Map<String, dynamic> updatedAlert) {
    setState(() {
      _alerts[index] = updatedAlert;
    });
  }

    // Function to navigate to EditAlert page
  void _editAlert(Map<String, dynamic> alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlert(
          alert: alert,
          onDelete: _deleteAlert, // Pass the delete function
          alertID: alert['id'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;
    final alertsList = userProfile?.alerts ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
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
                itemCount: alertsList?.length,
                itemBuilder: (context, index) {
                  final alert = alertsList?[index];
                  if (alert != null) {
                    return ListTile(
                        title: Text(alert['title']),
                        subtitle: Text(
                            'Date: ${alert['date']}, Time: ${alert['time']}'),
                        onTap: () async {
                          //Navigate to edit_alert page and wait for input
                          final updated_alert = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAlert(alert: alert, onDelete: _deleteAlert, alertID: alert['id'],),
                            ),
                          );
                          if (updated_alert != null) {
                            _updateAlert(index, updated_alert);
                          }
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
