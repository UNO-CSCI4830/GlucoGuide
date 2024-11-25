import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glucoguide/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text("Profile Page"),
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Text("Welcome, ${userProfile.name}!"),
            ),
    );
  }
}
