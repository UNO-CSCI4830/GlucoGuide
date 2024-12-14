import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ExportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> exportLogs(String userId) async {
    try {
      // Fetch logs from Firestore
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!userSnapshot.exists) {
        throw Exception('User data not found.');
      }

      final data = userSnapshot.data();
      final insulinDoseLogs =
          List<Map<String, dynamic>>.from(data?['insulinDoseLogs'] ?? []);
      final foodLogs = List<Map<String, dynamic>>.from(data?['foodLogs'] ?? []);

      // Create CSV data
      final List<List<String>> insulinRows = [
        ['Time', 'Dosage', 'Blood Glucose Level', 'Note']
      ];
      insulinDoseLogs.forEach((log) {
        insulinRows.add([
          log['time'],
          '${log['dosage']}',
          '${log['bloodGlucLevel']}',
          log['note']
        ]);
      });

      final List<List<String>> foodRows = [
        ['Time', 'Food Name', 'Calories', 'Protein', 'Carbohydrates', 'Fat']
      ];
      foodLogs.forEach((log) {
        foodRows.add([
          log['time'],
          log['food_name'],
          '${log['calories']}',
          '${log['protein']}',
          '${log['carbohydrates']}',
          '${log['fat']}'
        ]);
      });

      // Write to CSV
      final insulinCsv = const ListToCsvConverter().convert(insulinRows);
      final foodCsv = const ListToCsvConverter().convert(foodRows);

      // Get device directory
      final directory = await getApplicationDocumentsDirectory();
      final insulinFile = File('${directory.path}/insulin_logs.csv');
      final foodFile = File('${directory.path}/food_logs.csv');

      await insulinFile.writeAsString(insulinCsv);
      await foodFile.writeAsString(foodCsv);

      return 'Exported Insulin Dose and Food Logs to:\n${insulinFile.path}\n${foodFile.path}';
    } catch (e) {
      throw Exception('Failed to export logs: $e');
    }
  }
}
