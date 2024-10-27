import 'package:flutter/material.dart';
import 'package:glucoguide/components/bottom_navbar.dart';
import 'package:glucoguide/screens/app_settings/app_settings.dart';
import 'package:glucoguide/screens/food_tracker/food_tracker.dart';
import 'package:glucoguide/screens/home/home_page.dart';
import 'package:glucoguide/screens/profile/profile.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0; // current index of bottom nav

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const AppSettingsPage(),
    const FoodTrackerPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex], // Ensures proper display within safe area
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
