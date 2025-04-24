import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../components/charts/line_chart.dart';
import '../../../components/charts/range.dart';
import '../../../components/info_card.dart';
import '../../../services/api.service.dart';

class Salesoverview extends StatefulWidget {
  final num totalSales;
  final Map topSellingProducts;

  const Salesoverview(
      {super.key, required this.totalSales, required this.topSellingProducts});

  @override
  SalesoverviewState createState() => SalesoverviewState();
}

class SalesoverviewState extends State<Salesoverview> {
  dynamic rangeInfo;
  String selectedRange = 'Today';
  ApiService apiService = ApiService();
  List<FlSpot> spots = [];

  @override
  void initState() {
    getChartData('Today');
    super.initState();
  }

  handleRangeChanged(String rangeLabel) {
    setState(() {
      selectedRange = rangeLabel;
    });
    getChartData(selectedRange);
  }

  Future getChartData(dateRange) async {
    final range = getDateRange(dateRange);
    var data = await apiService
        .getRequest('analytics/get-sales-chart?filter=$dateRange');

    setState(() {
      spots.clear();
      data.data.forEach((item) {
        spots.add(FlSpot(item['for'], item['totalSales']));
      });
      rangeInfo = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;

    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 400,
        ),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            height: isBigScreen ? 1000 : 700,
            child: Column(
              children: [
                Align(
                  alignment:
                      isBigScreen ? Alignment.centerLeft : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(isBigScreen ? 8.0 : 4.0),
                    child: Text(
                      'Sales Overview',
                      style: TextStyle(
                          fontSize: isBigScreen ? 30 : 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: isBigScreen ? 14 : 0),
                    height: isBigScreen ? 350 : 175,
                    child: grids(isBigScreen, context)),
                SizedBox(height: 1),
                Divider(
                  color: Theme.of(context).colorScheme.surface,
                ),
                SizedBox(height: 5),
                Expanded(
                    child: MainLineChart(
                  onRangeChanged: handleRangeChanged,
                  rangeInfo: rangeInfo,
                  selectedRange: selectedRange,
                  spots: spots,
                  isCurved: true,
                ))
              ],
            )));
  }

  GridView grids(bool isBigScreen, BuildContext context) {
    return GridView.count(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        primary: true,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: isBigScreen ? 3 : 2,
        childAspectRatio: 3,
        children: [
          InfoCard(
            title: 'Today\'s Total Sales',
            icon: Icons.payments_outlined,
            currency: false,
            value: widget.totalSales.toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Today',
            icon: Icons.trending_up,
            currency: false,
            value: widget.topSellingProducts['topSellingToday'].isNotEmpty
                ? widget.topSellingProducts['topSellingToday'][0]['title']
                : 'No Sale Today',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Weekly',
            icon: Icons.trending_up,
            currency: false,
            value: widget.topSellingProducts['topSellingWeekly'].isNotEmpty
                ? widget.topSellingProducts['topSellingWeekly'][0]['title']
                : 'No Sale This Week',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Monthly',
            icon: Icons.trending_up,
            currency: false,
            value: widget.topSellingProducts['topSellingMonthly'].isNotEmpty
                ? widget.topSellingProducts['topSellingMonthly'][0]['title']
                : 'No Sale This Month',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          ),
        ]);
  }
}
