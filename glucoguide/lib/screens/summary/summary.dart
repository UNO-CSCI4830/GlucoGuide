import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  double _a1cGoal = 6.5; 

  void _updateA1CGoal() async {
  
    double? newGoal = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: const Text('Set New A1C Goal'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter new A1C goal',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, double.tryParse(_controller.text));
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
            Expanded(
              child: chartToRun(), 
            ),
          ],
        ),
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
