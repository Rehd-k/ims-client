import 'package:flutter/material.dart';

import '../../../components/chart.dart';
import '../../../components/info_card.dart';

class Salesoverview extends StatelessWidget {
  final num totalSales;
  final Map topSellingProducts;

  const Salesoverview(
      {super.key, required this.totalSales, required this.topSellingProducts});

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
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    height: isBigScreen ? 350 : 175,
                    child: grids(isBigScreen, context)),
                SizedBox(height: 1),
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                SizedBox(height: 5),
                Expanded(child: SalesLineChart())
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
            value: totalSales.toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Today',
            icon: Icons.trending_up,
            currency: false,
            value: topSellingProducts['topSellingToday'].isNotEmpty
                ? topSellingProducts['topSellingToday'][0]['title']
                : 'No Sale Today',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Weekly',
            icon: Icons.trending_up,
            currency: false,
            value: topSellingProducts['topSellingWeekly'].isNotEmpty
                ? topSellingProducts['topSellingWeekly'][0]['title']
                : 'No Sale This Week',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Top-Selling Products \n Monthly',
            icon: Icons.trending_up,
            currency: false,
            value: topSellingProducts['topSellingMonthly'].isNotEmpty
                ? topSellingProducts['topSellingMonthly'][0]['title']
                : 'No Sale This Month',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ]);
  }
}
