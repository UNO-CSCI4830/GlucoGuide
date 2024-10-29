import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlucoGuide'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(147, 36, 185, 156),
          child: const Center(
            child: Text(
              'Welcome to the Homepage!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
