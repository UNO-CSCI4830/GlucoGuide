import 'package:flutter/material.dart';
import 'package:glucoguide/components/insulin_calculator.dart';

class FoodTrackerPage extends StatefulWidget {
  const FoodTrackerPage({super.key});

  @override
  State<FoodTrackerPage> createState() => _FoodTrackerPageState();
}

class _FoodTrackerPageState extends State<FoodTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              InsulinDoseCalculator(),
            ],
          ),
        ),
      ),
    );
  }
}
