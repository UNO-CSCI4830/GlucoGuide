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
  // Function to delete an alert
  void _deleteAlert(Map<String, dynamic> alert) {
    // Access UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Remove the alert from the provider
    final currentAlerts =
        List<Map<String, dynamic>>.from(userProvider.userProfile?.alerts ?? []);
    currentAlerts.removeWhere(
        (a) => a['title'] == alert['title']); // Use title as identifier
    userProvider.updateUserProfile({'alerts': currentAlerts});

    setState(() {}); // Update the UI
  }

  // Function to add an alert to the list
  void _addAlert(Map<String, dynamic> alert) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Add the alert to the provider
    final currentAlerts =
        List<Map<String, dynamic>>.from(userProvider.userProfile?.alerts ?? []);
    currentAlerts.add(alert);
    userProvider.updateUserProfile({'alerts': currentAlerts});

    setState(() {}); // Update the UI
  }

  // Function to update an alert in the list
  void _updateAlert(Map<String, dynamic> updatedAlert) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Update the alert in the provider
    final currentAlerts =
        List<Map<String, dynamic>>.from(userProvider.userProfile?.alerts ?? []);
    final index = currentAlerts.indexWhere(
        (a) => a['title'] == updatedAlert['title']); // Use title as identifier
    if (index != -1) {
      currentAlerts[index] = updatedAlert;
      userProvider.updateUserProfile({'alerts': currentAlerts});
    }

    setState(() {}); // Update the UI
  }

  // Function to navigate to EditAlert page
  void _editAlert(Map<String, dynamic> alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlert(
          alert: alert,
          onDelete: _deleteAlert, // Pass the delete function
          alertID: alert['title'], // Use title as identifier
          alertsList: List<Map<String, dynamic>>.from(
              Provider.of<UserProvider>(context, listen: false)
                      .userProfile
                      ?.alerts ??
                  []), // Pass the actual alerts list
          onUpdateAlertsList: (updatedList) {
            // Update the UserProfile alerts list using the UserProvider
            Provider.of<UserProvider>(context, listen: false)
                .updateUserProfile({'alerts': updatedList});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userProfile = userProvider.userProfile;
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
                  MaterialPageRoute(builder: (context) => const AddAlert()),
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
                itemCount: alertsList.length,
                itemBuilder: (context, index) {
                  final alert = alertsList[index];
                  return ListTile(
                    title: Text(alert['title']),
                    subtitle:
                        Text('Date: ${alert['date']}, Time: ${alert['time']}'),
                    onTap: () async {
                      final updatedAlert = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAlert(
                            alert: alert,
                            onDelete: _deleteAlert, // Handle deletion
                            alertID: alert['title'], // Use title as identifier
                            alertsList: alertsList, // Pass alerts list
                            onUpdateAlertsList: (updatedList) {
                              // Update alerts list in UserProvider
                              userProvider
                                  .updateUserProfile({'alerts': updatedList});
                            },
                          ),
                        ),
                      );
                      if (updatedAlert != null) {
                        _updateAlert(updatedAlert); // Update the alert
                      }
                    },
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
