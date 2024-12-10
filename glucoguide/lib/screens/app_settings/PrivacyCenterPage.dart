import 'package:flutter/material.dart';
import 'package:glucoguide/screens/app_settings/PrivacyPolicy.dart';
import 'package:glucoguide/screens/app_settings/TermsOfService.dart';

class PrivacyCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Center'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Terms of Service'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsOfService()),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicy()),
              );
            },
          ),
        ],
      ),
    );
  }
}
