import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum RangeLabel {
  today('Today'),
  thisWeek('This Week'),
  lastWeek('Last Week'),
  nextMonth('Next Month'),
  lastMonth('Last Month'),
  firstQuarter('First Quarter'),
  secondQuarter('Second Quarter'),
  thirdQuarter('Third Quarter'),
  fourthQuarter('Fourth Quarter'),
  thisYear('This Year'),
  custorm('Custorm');

  const RangeLabel(this.label);
  final String label;
}

class SalesLineChart extends StatefulWidget {
  const SalesLineChart({super.key});

  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<SalesLineChart> {
  final List<FlSpot> salesData = [
    FlSpot(0, 10), // Monday sales: 3.5k
    FlSpot(1, 5), // Tuesday sales: 5k
    FlSpot(2, 20), // Wednesday sales: 4.2k
    FlSpot(3, 7), // Thursday sales: 6.5k
    FlSpot(4, 7), // Friday sales: 7k
    FlSpot(5, 80), // Saturday sales: 5.3k
    FlSpot(6, 70), // Sunday sales: 4k
    FlSpot(7, 53), // Monday sales: 3.5k
    FlSpot(8, 65), // Tuesday sales: 5k
    FlSpot(9, 38), // Wednesday sales: 4.2k
    FlSpot(10, 28), // Thursday sales: 6.5k
    FlSpot(11, 70), // Friday sales: 7k
    FlSpot(12, 58), // Saturday sales: 5.3k
    FlSpot(13, 40),
    FlSpot(14, 44),
  ];

  @override
  Widget build(BuildContext context) {
    final TextEditingController rangeController = TextEditingController();
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sales Data'),
                  DropdownMenu(
                    initialSelection: 'Today',
                    controller: rangeController,
                    requestFocusOnTap: true,
                    label: const Text('Select Range'),
                    // onSelected: (ColorLabel? color) {
                    //   setState(() {
                    //     selectedColor = color;
                    //   });
                    // },
                    dropdownMenuEntries: RangeLabel.values
                        .map<DropdownMenuEntry<String>>(
                            (RangeLabel rangeValue) {
                      return DropdownMenuEntry(
                        value: rangeValue.label,
                        label: rangeValue.label,
                        // style: MenuItemButton.styleFrom(
                        //   foregroundColor: color.color,
                        // ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(sideTitles: SideTitles()),
                    rightTitles: AxisTitles(sideTitles: SideTitles()),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          );
                          switch (value.toInt()) {
                            case 0:
                              return Text('8am', style: style);
                            case 1:
                              return Text('9am', style: style);
                            case 2:
                              return Text('10am', style: style);
                            case 3:
                              return Text('11am', style: style);
                            case 4:
                              return Text('12pm', style: style);
                            case 5:
                              return Text('1pm', style: style);
                            case 6:
                              return Text('2pm', style: style);
                            case 7:
                              return Text('3pm', style: style);
                            case 8:
                              return Text('4pm', style: style);
                            case 9:
                              return Text('5pm', style: style);
                            case 10:
                              return Text('6pm', style: style);
                            case 11:
                              return Text('7pm', style: style);
                            case 12:
                              return Text('8pm', style: style);
                            case 13:
                              return Text('9pm', style: style);
                            case 14:
                              return Text('10pm', style: style);
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('No Of Sales'),
                      sideTitles: SideTitles(
                        interval: 5,
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3),
                        left: BorderSide(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: salesData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withAlpha(2),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 14,
                  minY: 0,
                  maxY: 80,
                ),
              ),
            )
          ],
        ));
  }
}
