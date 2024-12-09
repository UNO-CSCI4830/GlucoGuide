import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:glucoguide/screens/app_settings/AboutUsPage.dart';
import 'package:glucoguide/screens/app_settings/ChangePasswordPage.dart';
import 'package:glucoguide/screens/app_settings/ContactSupportPage.dart';
import 'package:glucoguide/screens/app_settings/DeleteAccountPage.dart';
import 'package:glucoguide/screens/app_settings/EditProfilePage.dart';
import 'package:glucoguide/screens/app_settings/PrivacyCenterPage.dart';
import 'package:glucoguide/screens/login/login_page.dart';
import 'package:provider/provider.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _MyAccountState();
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

class _MyAccountState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settings = [
      SettingItem(
        title: 'My Account',
      ),
      SettingItem(
        title: 'Edit Profile',
        icon: Icons.manage_accounts,
        nextPage: EditProfilePage(),
      ),
      SettingItem(
        title: 'Delete Account',
        icon: Icons.delete,
        nextPage: DeleteAccountPage(),
      ),
      SettingItem(
        title: 'Change Password',
        icon: Icons.lock_open,
        nextPage: ChangePasswordPage(),
      ),
      SettingItem(
        title: 'Log Out',
        icon: Icons.logout_rounded,
        nextPage: null,
      ),
      SettingItem(
        // Index = 5
        title: 'Settings',
      ),
      SettingItem(
        title: 'Privacy Center',
        icon: Icons.lock,
        nextPage: PrivacyCenterPage(),
      ),
      SettingItem(
        // Index = 7
        title: 'Help',
      ),
      SettingItem(
        title: 'About Us',
        icon: Icons.groups,
        nextPage: AboutUsPage(),
      ),
      SettingItem(
        title: 'Contact Support',
        icon: Icons.contact_support,
        nextPage: ContactSupportPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
          itemCount: settings.length, // Plus 1 to add header
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('My Account',
                      style: TextStyle(
                        fontSize: 18,
                      )));
            }
            if (index == 5) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Settings',
                      style: TextStyle(
                        fontSize: 18,
                      )));
            }
            if (index == 7) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Help',
                      style: TextStyle(
                        fontSize: 18,
                      )));
            }
            final setting = settings[index];
            return ListTile(
              leading: Icon(setting.icon),
              title: Text(setting.title),
              onTap: () {
                if (setting.nextPage == null) {
                  _handleLogout(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => setting.nextPage!,
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}

// Make Icon and Widget optional in the future,
// so if statement can be removed.
class SettingItem {
  final String title;
  final IconData? icon;
  Widget? nextPage;

  SettingItem({
    required this.title,
    this.icon,
    this.nextPage,
  });
}
