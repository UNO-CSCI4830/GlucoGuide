import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

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
  List<BloodGlucoseLog> _glucoseLogs = [];

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
            _buildGlucoseLogList(),

            Expanded(
              child: chartToRun(), 
            ),
          ],
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
          style: TextStyle(fontSize: 18,
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
          style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          child: Text("Add Reading"),
        ),
      ],
    );
  }

void _addGlucoseReading(double level) {
    setState(() {
    _glucoseLogs.add(BloodGlucoseLog(date: DateTime.now(), level: level));
    });
  }

  Widget _buildGlucoseLogList() {



    return Expanded(
      child: ListView.builder(
        itemCount: _glucoseLogs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${_glucoseLogs[index].level} mg/dL",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),           
            ),
            subtitle: Text(_glucoseLogs[index].date.toIso8601String(),
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            tileColor: Color.fromARGB(255, 92, 16, 16),
          );
        },
      ),
    );
  }


  Widget chartToRun() {

    var chartOptions = ChartOptions();

    
    var chartData = ChartData(
      dataRows: [
        [10.0, 20.0, 30.0, 40.0, 50.0], 
        [15.0, 25.0, 35.0, 45.0, 55.0], 
      ],
      xUserLabels: ["Jan", "Feb", "Mar", "Apr", "May"], 
      dataRowsLegends: ["Line 1", "Line 2"], 
      chartOptions: chartOptions, 
    );

    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
    );

    var lineChartPainter = LineChartPainter(
      lineChartContainer: lineChartContainer,
    );

    return LineChart(
      painter: lineChartPainter,
      size: const Size(400, 300), 
    );
  }
}
