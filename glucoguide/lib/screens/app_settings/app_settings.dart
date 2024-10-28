import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/screens/app_settings/AccountSettingsPage.dart';
import 'package:glucoguide/screens/app_settings/NotificationSettingsPage.dart';
import 'package:glucoguide/screens/login/login_page.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settings = [
      SettingItem(
        title: 'Account',
        icon: Icons.settings,
        nextPage: AccountSettingsPage(),
      ),
      SettingItem(
        title: 'Notifications',
        icon: Icons.notifications,
        nextPage: NotificationSettingsPage(),
      ),
      SettingItem(
        title: 'Log Out',
        icon: Icons.logout_rounded,
        // make this secure
        nextPage: LoginPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}

class SettingItem {
  final String title;
  final IconData icon;
  final Widget nextPage;

  SettingItem({
    required this.title,
    required this.icon,
    required this.nextPage,
  });
}
