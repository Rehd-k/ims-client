import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'range.dart';

import '../../theme.dart';

class LineChartSample1 extends StatelessWidget {
  final Function(String) onRangeChanged;
  final dynamic rangeInfo;
  final String selectedRange;

  const LineChartSample1({
    super.key,
    required this.onRangeChanged,
    required this.rangeInfo,
    required this.selectedRange,
  });

  @override
  Widget build(BuildContext context) {
    late List<ChartTitle> bottomTitles;
    late List<ChartTitle> leftTitles;

    // Example data - replace with your backend call
    bottomTitles = rangeInfo.titles;

    leftTitles = [
      ChartTitle(value: 1, label: '1m'),
      ChartTitle(value: 2, label: '2m'),
      ChartTitle(value: 3, label: '3m'),
      ChartTitle(value: 4, label: '5m'),
      ChartTitle(value: 5, label: '6m'),
      ChartTitle(value: 6, label: '7m'),
      ChartTitle(value: 7, label: '8m'),
      ChartTitle(value: 8, label: '9m'),
      ChartTitle(value: 9, label: '10m'),
      ChartTitle(value: 10, label: '11m'),
      ChartTitle(value: 11, label: '12m'),
      ChartTitle(value: 12, label: '13m'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Sales Visualization',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            DropdownButton<String>(
              value: selectedRange,
              items: RangeLabel.values
                  .map<DropdownMenuItem<String>>((RangeLabel value) {
                return DropdownMenuItem<String>(
                  value: value.label,
                  child: Text(value.label),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onRangeChanged(newValue);
                }
              },
            )
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: _LineChart(
              bottomTitlesData: bottomTitles,
              leftTitlesData: leftTitles,
              xAxis: rangeInfo.xAxis,
            ),
          ),
        ),
      ],
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<ChartTitle> bottomTitlesData;
  final List<ChartTitle> leftTitlesData;
  final double xAxis;

  const _LineChart({
    required this.bottomTitlesData,
    required this.leftTitlesData,
    required this.xAxis,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: LineTouchData(),
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: [lineChartBarData2_3],
        minX: 0,
        maxX: xAxis,
        maxY: 12,
        minY: 0,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    final title = leftTitlesData.firstWhere(
      (element) => element.value == value.toInt(),
      orElse: () => ChartTitle(value: -1, label: ''),
    );

    if (title.value == -1) return Container();

    return SideTitleWidget(
      meta: meta,
      child: Text(
        title.label,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    final title = bottomTitlesData.firstWhere((element) {
      // print(element);
      return element.value == value.toInt();
    }, orElse: () => ChartTitle(value: -1, label: ''));

    return SideTitleWidget(
      meta: meta,
      space: 20,
      child: Text(
        title.value == -1 ? '' : title.label,
        style: style,
      ),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2), width: 4),
          left: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.primaryVariant.withValues(alpha: 0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [FlSpot(1, 3.8), FlSpot(2, 1.9), FlSpot(3, 5)],
      );
}
