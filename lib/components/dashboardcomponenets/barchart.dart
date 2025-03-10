import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Barchart extends StatelessWidget {
  final List<BarChartGroupData> cashInData;
  final List<BarChartGroupData> cashOutData;
  final String period;

  const Barchart({
    super.key,
    required this.cashInData,
    required this.cashOutData,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Cash In vs Cash Out for $period'),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              barGroups: [
                ...cashInData,
                ...cashOutData,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
