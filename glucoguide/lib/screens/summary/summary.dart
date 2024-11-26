import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key); // Constructor with Key

  @override
  Widget build(BuildContext context) {
    Widget chart = chartToRun(); // Create the chart using the chartToRun function

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: chart, // Display the chart widget
            ),
          ],
        ),
      ),
    );
  }

  Widget chartToRun() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Example shows a demo-type data generated randomly in a range.
    chartData = RandomChartData.generated(chartOptions: chartOptions);
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}
