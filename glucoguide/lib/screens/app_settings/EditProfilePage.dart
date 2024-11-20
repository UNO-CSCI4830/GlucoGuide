import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _MyAccountState();
}

class _MyAccountState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    final List<EditProfileItems> settings = [
      EditProfileItems(title: 'User Name', text: userProfile!.name),
      EditProfileItems(title: 'Profile Photo', text: '', icon: Icons.person),
      EditProfileItems(
          title: 'Height', text: (userProfile.height).toString() + ' cm'),
      EditProfileItems(title: 'Sex', text: userProfile.gender),
      EditProfileItems(title: 'Date of Birth', text: userProfile.dateOfBirth),
      EditProfileItems(title: 'Location', text: userProfile.country),
      EditProfileItems(title: 'Units', text: userProfile.unit),
      EditProfileItems(
        title: 'Email',
        text: userProfile.email,
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
