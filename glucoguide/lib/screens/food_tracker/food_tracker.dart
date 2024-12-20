import 'package:flutter/material.dart';
import 'package:glucoguide/insulin_calculator/insulin_calculator.dart';
import 'package:glucoguide/insulin_calculator/food_search.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tracking',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(147, 36, 185, 156),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              const Color.fromARGB(255, 82, 143, 193)!
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  title: 'Insulin Dose Calculator',
                  child: const InsulinDoseCalculator(),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  title: 'Food Search',
                  child: const FoodSearchWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
