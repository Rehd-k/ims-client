import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Linegraph extends StatelessWidget {
  final List<FlSpot> revenueData;
  final List<FlSpot> expensesData;
  final List<FlSpot> profitData;
  final String period;

  const Linegraph({
    super.key,
    required this.revenueData,
    required this.expensesData,
    required this.profitData,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Revenue, Expenses, and Profit for $period'),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles()),
                leftTitles: AxisTitles(sideTitles: SideTitles()),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: revenueData,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 4,
                ),
                LineChartBarData(
                  spots: expensesData,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                ),
                LineChartBarData(
                  spots: profitData,
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
