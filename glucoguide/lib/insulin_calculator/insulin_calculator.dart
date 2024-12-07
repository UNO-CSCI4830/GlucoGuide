import 'package:flutter/material.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

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

  double? insulinDose;
  bool canCalculateDose = false;

  void updateButtonState() {
    setState(() {
      canCalculateDose =
          glucoseController.text.isNotEmpty && carbsController.text.isNotEmpty;
    });
  }

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

      glucoseController.clear();
      carbsController.clear();

      canCalculateDose = false;

      FocusScope.of(context).unfocus();
    });

    // Log the dose in a Map<String, dynamic> so it fits in the db
    // list properly, all logs will be the same way, and alerts.
    final insulinDoseLog = {
      'time': DateTime.now().toString(),
      'dosage': insulinDose,
      'bloodGlucLevel': glucose,
      'note': 'test dose'
    };

    // instantiate user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // get current insulin dose logs and append the new log
    final currentLogs = List<Map<String, dynamic>>.from(
        userProvider.userProfile?.insulinDoseLogs ?? []);
    currentLogs.add(insulinDoseLog);

    // update userProfile
    userProvider.updateUserProfile({'insulinDoseLogs': currentLogs});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: glucoseController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Blood Glucose (mg/dL)'),
          onChanged: (value) => updateButtonState(),
        ),
        TextField(
          controller: carbsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Carbs (g)'),
          onChanged: (value) => updateButtonState(),
        ),
        TextField(
          controller: sensitivityFactorController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Sensitivity Factor'),
        ),
        TextField(
          controller: carbRatioController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Carb Ratio'),
        ),
        TextField(
          controller: targetGlucoseController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Target Glucose (mg/dL)'),
        ),
        ElevatedButton(
          onPressed: canCalculateDose ? calculateDose : null,
          child: const Text('Calculate Dose'),
        ),
        if (insulinDose != null)
          Text('Dose: ${insulinDose!.toStringAsFixed(2)} units'),
      ],
    );
  }
}
