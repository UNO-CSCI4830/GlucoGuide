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
      TextEditingController();
  final TextEditingController carbRatioController = TextEditingController();
  final TextEditingController targetGlucoseController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  double insulinDose = 0.0;
  bool canCalculateDose = false;

  void updateButtonState() {
    setState(() {
      canCalculateDose =
          glucoseController.text.isNotEmpty && carbsController.text.isNotEmpty;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color.fromARGB(255, 228, 139, 133),
    ));
  }

  void calculateDose() {
    final glucose = double.tryParse(glucoseController.text) ?? 0.0;
    final carbs = double.tryParse(carbsController.text) ?? 0.0;
    final sensitivityFactor =
        double.tryParse(sensitivityFactorController.text) ?? 0.0;
    final carbRatio = double.tryParse(carbRatioController.text) ?? 0.0;
    final targetGlucose = double.tryParse(targetGlucoseController.text) ?? 0.0;
    final note = noteController.text;

    if (glucose <= 0) {
      _showError("Please enter a valid glucose value.");
      return;
    }
    if (carbs < 0) {
      _showError("Please enter a valid carb value.");
      return;
    }
    if (sensitivityFactor <= 0) {
      _showError("Sensitivity factor must be greater than 0.");
      return;
    }
    if (carbRatio <= 0) {
      _showError("Carb ratio must be greater than 0.");
      return;
    }
    if (targetGlucose < 0) {
      _showError("Please enter a valid target glucose value.");
      return;
    }

    setState(() {
      insulinDose =
          ((glucose - targetGlucose) / sensitivityFactor) + (carbs / carbRatio);
    });

    final insulinDoseLog = {
      'time': DateTime.now().toString(),
      'dosage': insulinDose,
      'bloodGlucLevel': glucose,
      'note': note.isEmpty ? "No note provided" : note,
    };

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final currentLogs = List<Map<String, dynamic>>.from(
        userProvider.userProfile?.insulinDoseLogs ?? []);
    currentLogs.add(insulinDoseLog);

    userProvider.updateUserProfile({'insulinDoseLogs': currentLogs});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: glucoseController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Blood Glucose (mg/dL)'),
          onChanged: (value) => updateButtonState(),
        ),
        TextField(
          controller: carbsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Carbs (g)'),
          onChanged: (value) => updateButtonState(),
        ),
        TextField(
          controller: sensitivityFactorController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Sensitivity Factor'),
        ),
        TextField(
          controller: carbRatioController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Carb Ratio'),
        ),
        TextField(
          controller: targetGlucoseController,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Target Glucose (mg/dL)'),
        ),
        TextField(
          controller: noteController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Note (optional)'),
        ),
        ElevatedButton(
          onPressed: canCalculateDose ? calculateDose : null,
          child: const Text('Calculate Dose'),
        ),
        if (insulinDose > 0)
          Text('Dose: ${insulinDose.toStringAsFixed(2)} units'),
      ],
    );
  }
}
