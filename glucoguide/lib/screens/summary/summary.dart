import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

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
            Expanded(
              child: chartToRun(), // Shows the chart
            ),
          ],
        ),
      ),
    );
  }

  Widget chartToRun() {
    // Shows Options
    var chartOptions = ChartOptions();

    // Shows Data
    var chartData = ChartData(
      dataRows: [
        [10.0, 20.0, 30.0, 40.0, 50.0], // Data for line 1
        [15.0, 25.0, 35.0, 45.0, 55.0], // Data for line 2
      ],
      xUserLabels: ["Jan", "Feb", "Mar", "Apr", "May"], // X-axis
      dataRowsLegends: ["Line 1", "Line 2"], // Legends for the lines
      chartOptions: chartOptions, // Chart configuration options
    );

    // Create the LineChartTopContainer
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
    );

    // Create the LineChartPainter
    var lineChartPainter = LineChartPainter(
      lineChartContainer: lineChartContainer,
    );

    // Return the LineChart widget
    return LineChart(
      painter: lineChartPainter,
      size: const Size(400, 300), // Size of chart
    );
  }
}
