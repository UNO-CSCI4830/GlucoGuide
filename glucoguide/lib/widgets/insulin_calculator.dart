import 'package:flutter/material.dart';

class InsulinDoseCalculator extends StatefulWidget {
  const InsulinDoseCalculator({super.key});

  @override
  State<InsulinDoseCalculator> createState() => _InsulinDoseCalculatorState();
}

class _InsulinDoseCalculatorState extends State<InsulinDoseCalculator> {
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController sensitivityFactorController =
      TextEditingController(text: '50');
  final TextEditingController carbRatioController =
      TextEditingController(text: '10');
  final TextEditingController targetGlucoseController =
      TextEditingController(text: '100');

  double insulinDose = 0.0;

  void calculateDose() {
    final glucose = double.tryParse(glucoseController.text) ?? 0.0;
    final carbs = double.tryParse(carbsController.text) ?? 0.0;
    final sensitivityFactor =
        double.tryParse(sensitivityFactorController.text) ?? 50.0;
    final carbRatio = double.tryParse(carbRatioController.text) ?? 10.0;
    final targetGlucose =
        double.tryParse(targetGlucoseController.text) ?? 100.0;

    setState(() {
      insulinDose =
          ((glucose - targetGlucose) / sensitivityFactor) + (carbs / carbRatio);
    });
  }
}
