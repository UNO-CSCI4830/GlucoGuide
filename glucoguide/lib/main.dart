import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the homepage page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlucoGuide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Login Page class
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to show the login dialog
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without logging in
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(147, 36, 185, 156),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // Perform the login and navigate to Homepage
                Navigator.of(context).pop(); // Close the dialog
                _navigateToHomepage(context);
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  // Method to navigate to the homepage with animation
  void _navigateToHomepage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Homepage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin =
              Offset(1.0, 0.0); // Start position (offscreen to the right)
          const end = Offset.zero; // End position (onscreen)
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlucoGuide'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to GlucoGuide',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(147, 36, 185, 156),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // Show the login dialog when the button is pressed
                _showLoginDialog(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
