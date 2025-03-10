import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../components/dashboardcomponenets/barchart.dart';
import '../../../components/dashboardcomponenets/linegraph.dart';

class Financialsummary extends StatefulWidget {
  const Financialsummary({super.key});

  @override
  FinancialsummaryState createState() => FinancialsummaryState();
}

class FinancialsummaryState extends State<Financialsummary> {
  // Example data
  final List<FlSpot> revenueData = [
    FlSpot(0, 1200000),
    FlSpot(1, 1300000),
    FlSpot(2, 1250000),
  ];
  final List<FlSpot> expensesData = [
    FlSpot(0, 800000),
    FlSpot(1, 850000),
    FlSpot(2, 820000),
  ];
  final List<FlSpot> profitData = [
    FlSpot(0, 400000),
    FlSpot(1, 450000),
    FlSpot(2, 430000),
  ];
  final List<BarChartGroupData> cashInData = [
    BarChartGroupData(
        x: 0, barRods: [BarChartRodData(color: Colors.green, toY: 1000000)]),
    BarChartGroupData(
        x: 1, barRods: [BarChartRodData(color: Colors.green, toY: 1100000)]),
  ];
  final List<BarChartGroupData> cashOutData = [
    BarChartGroupData(
        x: 0, barRods: [BarChartRodData(color: Colors.red, toY: 500000)]),
    BarChartGroupData(
        x: 1, barRods: [BarChartRodData(color: Colors.red, toY: 600000)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
      ),
      child: Column(
        children: [
          Linegraph(
            revenueData: revenueData,
            expensesData: expensesData,
            profitData: profitData,
            period: 'this month',
          ),
          Barchart(
            cashInData: cashInData,
            cashOutData: cashOutData,
            period: 'this week',
          ),
        ],
      ),
    );
  }
}
