import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex; // The current index of the active tab
  final Function(int) onTap; // Callback to handle taps

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 42.69,
      currentIndex: currentIndex,
      onTap: onTap, // Trigger callback when a tab is tapped
      unselectedItemColor: Colors.black,
      selectedItemColor: const Color.fromARGB(255, 28, 184, 152),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Track',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Summary',
        ),
      ],
    );
  }
}
