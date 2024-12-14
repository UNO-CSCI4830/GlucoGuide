import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'add_alert.dart';
import 'edit_alert.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    initializeFCM();
  }

  // Initialize Local Notifications
  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tapped logic here
        if (response.payload != null) {
          print('Notification payload: ${response.payload}');
          final alerts = jsonDecode(response.payload!);
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.updateUserProfile({'alerts': alerts});
          setState(() {});
        }
      },
    );
  }

  Future<void> initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.containsKey('alerts')) {
        final newAlerts = List<Map<String, dynamic>>.from(
          jsonDecode(message.data['alerts']),
        );

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUserProfile({'alerts': newAlerts});
        setState(() {});
      }

      _showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

// Function to display the notification
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alerts_channel', // Channel ID
      'Alerts Notifications', // Channel Name
      channelDescription: 'Channel for alert notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (you can use any unique ID)
      message.notification?.title ?? 'Alert', // Notification title
      message.notification?.body ?? 'You have a new alert', // Notification body
      platformChannelSpecifics,
      payload: message
          .data['alerts'], // Optional: payload can contain additional data
    );
  }

// Fetch alerts from UserProvider
  Future<List<Map<String, dynamic>>> fetchAlerts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return List<Map<String, dynamic>>.from(
        userProvider.userProfile?.alerts ?? []);
  }

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
    final index = currentAlerts.indexWhere((alert) =>
        alert['title'] == updatedAlert['title']); // Use title as identifier
    if (index != -1) {
      currentAlerts[index] = updatedAlert;
      userProvider.updateUserProfile({'alerts': currentAlerts});
    }

    setState(() {}); // Update the UI
  }

  // Function to navigate to EditAlert page
  void _editAlert(Map<String, dynamic> alert, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlert(
          alert: alert,
          alertIndex: index, // Pass index instead of alertID
          alertsList: List<Map<String, dynamic>>.from(
              Provider.of<UserProvider>(context, listen: false)
                      .userProfile
                      ?.alerts ??
                  []),
          onDelete: (alert) {
            _deleteAlert(alert);
          },
          onUpdateAlertsList: (updatedList) {
            Provider.of<UserProvider>(context, listen: false)
                .updateUserProfile({'alerts': updatedList});
            setState(() {});
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
        backgroundColor: const Color.fromARGB(147, 36, 185, 156),
        automaticallyImplyLeading: false,
        title: const Text(
          'Alerts Page',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
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
                            alertIndex: index, // Use title as identifier
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
