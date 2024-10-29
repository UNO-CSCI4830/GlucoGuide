import 'package:flutter/material.dart';
import 'package:glucoguide/screens/app_settings/AboutUsPage.dart';
import 'package:glucoguide/screens/app_settings/ChangePasswordPage.dart';
import 'package:glucoguide/screens/app_settings/ContactSupportPage.dart';
import 'package:glucoguide/screens/app_settings/DeleteAccountPage.dart';
import 'package:glucoguide/screens/app_settings/EditProfilePage.dart';
import 'package:glucoguide/screens/app_settings/NotificationSettingsPage.dart';
import 'package:glucoguide/screens/app_settings/PrivacyCenterPage.dart';
import 'package:glucoguide/screens/app_settings/PushNotificationPage.dart';
import 'package:glucoguide/screens/app_settings/ReminderPage.dart';
import 'package:glucoguide/screens/login/login_page.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _MyAccountState();
}

class _MyAccountState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settings = [
      SettingItem(
        title: 'My Account',
        nextPage: NotificationSettingsPage(),
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
        // make this secure
        nextPage: LoginPage(),
      ),
      SettingItem(
        // Index = 5
        title: 'Settings',
        nextPage: NotificationSettingsPage(),
      ),
      SettingItem(
        title: 'Reminders',
        icon: Icons.event,
        nextPage: ReminderPage(),
      ),
      SettingItem(
        title: 'Privacy Center',
        icon: Icons.lock,
        nextPage: PrivacyCenterPage(),
      ),
      SettingItem(
        title: 'Push Notifications',
        icon: Icons.notifications,
        nextPage: PushNotificationPage(),
      ),
      SettingItem(
        // Index = 9
        title: 'Help',
        nextPage: NotificationSettingsPage(),
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
            if (index == 9) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => setting.nextPage,
                  ),
                );
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
  final Widget nextPage;

  SettingItem({
    required this.title,
    this.icon,
    required this.nextPage,
  });
}
