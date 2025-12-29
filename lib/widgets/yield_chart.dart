import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class YieldChart extends StatelessWidget {
  final double interest;

  const YieldChart({super.key, required this.interest});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Expected Yield",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  spots: [
                    const FlSpot(0, 0),
                    FlSpot(1, interest / 3),
                    FlSpot(2, interest / 2),
                    FlSpot(3, interest),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
