import 'package:flutter/material.dart';
import 'package:glucoguide/widgets/insulin_calculator.dart';

class FoodTrackerPage extends StatefulWidget {
  const FoodTrackerPage({super.key});

  @override
  State<FoodTrackerPage> createState() => _FoodTrackerPageState();
}

class _FoodTrackerPageState extends State<FoodTrackerPage> {
  @override
  Widget build(BuildContext context) {
    InsulinDoseCalculator();
    return const Placeholder();
  }
}
