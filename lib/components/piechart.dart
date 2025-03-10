import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartScreen extends StatefulWidget {
  const PieChartScreen({super.key});

  @override
  PiechartState createState() => PiechartState();
}

class PiechartState extends State<PieChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
        child: SizedBox(
            height: 250,
            child: Stack(children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: 250,
                  sectionsSpace: 0,
                  centerSpaceRadius: 100,
                  sections: [
                    PieChartSectionData(
                      value: 45,
                      color: Colors.greenAccent,
                      radius: 45,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 35,
                      color: Colors.blue.shade900,
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.grey.shade400,
                      radius: 20,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10.0,
                            spreadRadius: 10.0,
                            offset: const Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "2305",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ])));
  }
}
