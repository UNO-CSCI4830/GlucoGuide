import 'package:flutter/material.dart';
import 'package:glucoguide/widgets/insulin_calculator.dart';
import 'package:glucoguide/widgets/food_search.dart';

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
        title: const Text('Tracking'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              InsulinDoseCalculator(),
              SizedBox(height: 20),
              FoodSearch(),
            ],
          ),
        ),
      ),
    );
  }
}
