import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/insulin_calculator/export_functionality.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String name = user?.email.toString() ?? "User";

    final ExportService exportService = ExportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(147, 36, 185, 156),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export',
            onPressed: () async {
              if (user != null) {
                try {
                  final exportMessage =
                      await exportService.exportLogs(user.uid);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(exportMessage)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not logged in')),
                );
              }
            },
          ),
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
                child: Text('Other'),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.pushNamed(context, '/app_settings');
              } else if (value == 2) {}
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $name!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
