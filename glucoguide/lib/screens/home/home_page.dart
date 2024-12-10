import 'package:flutter/material.dart';
import '../summary/summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome To GlucoGuide!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(147, 36, 185, 156),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Log Out'),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.pushNamed(context, '/app_settings');
              }
              if (value == 2) {
                _handleLogout(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${userProfile!.name}!",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 20, 100, 160),
                ),
              ),
              const SizedBox(height: 20),

              // Current Blood Glucose Level
              CurrentBloodGlucoseWidget(userId: user?.uid ?? ""),

              const SizedBox(height: 20),

              // Insulin Dose Logs
              const Text(
                "Recent Insulin Dose Logs",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 20, 90, 150),
                ),
              ),
              const SizedBox(height: 10),
              InsulinDoseLogsWidget(userId: user?.uid ?? ""),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SummaryPage()),
                  );
                },
                child: const Text('Go to Summary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentBloodGlucoseWidget extends StatelessWidget {
  final String userId;

  const CurrentBloodGlucoseWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
              "Unable to fetch current blood glucose",
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          );
        }

        // Extract insulin dose logs and current blood glucose
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final insulinDoseLogs = (userData['insulinDoseLogs'] as List<dynamic>?)
            ?.map((log) => log as Map<String, dynamic>)
            .toList();

        // Get current blood glucose level (from last log)
        final currentBloodGlucose =
            (insulinDoseLogs?.last)?['bloodGlucLevel'] ?? "N/A";

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.blueAccent.withOpacity(0.1),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Blood Glucose Level",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 90, 180),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "$currentBloodGlucose mg/dL",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InsulinDoseLogsWidget extends StatelessWidget {
  final String userId;

  const InsulinDoseLogsWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
              "No insulin dose logs available",
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          );
        }

        // Extract insulin dose logs from Firestore
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final insulinDoseLogs = (userData['insulinDoseLogs'] as List<dynamic>?)
            ?.map((log) => log as Map<String, dynamic>)
            .toList();

        if (insulinDoseLogs == null || insulinDoseLogs.isEmpty) {
          return const Center(
            child: Text(
              "No logs available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Sort logs by time (descending)
        insulinDoseLogs.sort((a, b) {
          final timeA = DateTime.parse(a['time']);
          final timeB = DateTime.parse(b['time']);
          return timeB.compareTo(timeA); // Most recent logs first
        });

        return SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            itemCount: insulinDoseLogs.length,
            itemBuilder: (context, index) {
              final log = insulinDoseLogs[index];
              final bloodGlucLevel = log['bloodGlucLevel'] ?? "N/A";
              final dosage = log['dosage'] ?? "N/A";
              final note = log['note'] ?? "N/A";
              final time = DateTime.parse(log['time']).toLocal();

              return Card(
                color: const Color.fromARGB(255, 200, 240, 255),
                shadowColor: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Blood Glucose: $bloodGlucLevel mg/dL",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 20, 90, 150),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Dosage: $dosage units",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Note: $note",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Time: $time",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Future<void> _handleLogout(BuildContext context) async {
  try {
    // Sign out the user from Firebase
    await FirebaseAuth.instance.signOut();

    // Clear the UserProvider state
    Provider.of<UserProvider>(context, listen: false).clearUserProfile();

    // Navigate to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Remove all previous routes
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error logging out: $e')),
    );
  }
}
