import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _MyAccountState();
}

class _MyAccountState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String name = user?.email.toString() ?? "User";

    final List<EditProfileItems> settings = [
      EditProfileItems(title: 'User Name', text: '[Username Here]'),
      EditProfileItems(title: 'Profile Photo', text: '', icon: Icons.person),
      EditProfileItems(title: 'Height', text: '[Height Here]'),
      EditProfileItems(title: 'Sex', text: '[Sex Here]'),
      EditProfileItems(title: 'Date of Birth', text: '[Date of Birth Here]'),
      EditProfileItems(title: 'Location', text: '[Location Here]'),
      EditProfileItems(title: 'Units', text: '[Units Here]'),
      EditProfileItems(
        title: 'Email',
        text: name,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView.builder(
          itemCount: settings.length, // Plus 1 to add header
          itemBuilder: (context, index) {
            final setting = settings[index];
            return ListTile(
              title: Text(setting.title),
              subtitle: Text(setting.text),
              trailing: Icon(setting.icon),
            );
          }),
    );
  }
}

// Make Icon and Widget optional in the future,
// so if statement can be removed.
class EditProfileItems {
  final String title;
  final IconData? icon;
  final String text;

  EditProfileItems({
    required this.title,
    this.icon,
    required this.text,
  });
}
