import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BloodGlucoseLog {
  final DateTime date;
  final double level;

  BloodGlucoseLog({required this.date, required this.level});
}

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  SummaryPageState createState() => SummaryPageState();
}

class SummaryPageState extends State<SummaryPage> {
  double _a1cGoal = 6.5;
  final List<BloodGlucoseLog> _glucoseLogs = [];

  void _updateA1CGoal() async {
    double? newGoal = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Set New A1C Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter new A1C goal',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, double.tryParse(controller.text));
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (newGoal != null) {
      setState(() {
        _a1cGoal = newGoal;
      });
    }
  }

  void _addGlucoseReading(double level) {
    // update user profile via user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _glucoseLogs.add(BloodGlucoseLog(date: DateTime.now(), level: level));
      final int mostRecentLevel =
          _glucoseLogs.last.level.toInt(); // Access 'level' and convert to int

      if (mostRecentLevel != null) {
        userProvider
            .updateUserProfile({'currentGlucoseLevel': mostRecentLevel});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Summary',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(147, 36, 185, 156),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (Route<dynamic> route) => false);
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'A1C Goal: $_a1cGoal%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateA1CGoal,
                    child: const Text('Set New Goal'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGlucoseEntryUI(),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: chartToRun(),
              ),
              const SizedBox(height: 20),
              if (_glucoseLogs.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 92, 16, 16).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: Color.fromARGB(255, 92, 16, 16), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Most Recent Blood Glucose:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_glucoseLogs.last.level} mg/dL",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Logged at: ${_formatTime(_glucoseLogs.last.date)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucoseEntryUI() {
    TextEditingController glucoseController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Add New Glucose Reading",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: glucoseController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Glucose Level (mg/dL)",
            labelStyle: TextStyle(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (glucoseController.text.isNotEmpty) {
              _addGlucoseReading(double.parse(glucoseController.text));
              glucoseController.clear();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          child: Text("Add Reading"),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? "PM" : "AM";
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

// _addGlucoseReading was here before
// _buildGlucoseLogList was here

  // chart help from fl_chart community
  Widget chartToRun() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 100,
                getTitlesWidget: (value, meta) {
                  if (value % 100 == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < _glucoseLogs.length) {
                    final log = _glucoseLogs[value.toInt()];
                    return Text(
                      _formatHour(log.date),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    );
                  }
                  return const Text("");
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          minX: 0,
          maxX: _glucoseLogs.isEmpty ? 0 : _glucoseLogs.length.toDouble() - 1,
          minY: 0,
          maxY: 500,
          lineBarsData: [
            LineChartBarData(
              spots: _glucoseLogs
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.level))
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 92, 16, 16),
                  const Color.fromARGB(255, 92, 16, 16),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 92, 16, 16).withOpacity(0.2),
                    const Color.fromARGB(255, 158, 55, 55).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHour(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
}
