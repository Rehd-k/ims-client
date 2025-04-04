import 'package:flutter/material.dart';

import '../../../components/info_card.dart';

class Inventorysummery extends StatelessWidget {
  final Map data;
  const Inventorysummery({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;

    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: isBigScreen ? 450 : 350,
        ),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Align(
                  alignment:
                      isBigScreen ? Alignment.centerLeft : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(isBigScreen ? 8.0 : 4.0),
                    child: Text(
                      'Inventory Summary',
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
                    height: isBigScreen ? 400 : 297,
                    child: grids(isBigScreen, context)),
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
            title: 'No. of Products',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['totalProducts'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Total Stock',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['totalQuantity'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Total Stock Value',
            icon: Icons.payments_outlined,
            currency: true,
            value: data['totalValue'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: 'Low Stock',
            icon: Icons.trending_up,
            currency: false,
            value: data['lowStockCount'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Colors.redAccent,
          ),
          InfoCard(
            title: 'Expired/Expiring',
            icon: Icons.trending_up,
            currency: false,
            value: data['expiredProducts'] == null
                ? 'No Data'
                : data['expiredProducts'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.error,
          ),
          InfoCard(
            title: 'Fast-Moving',
            icon: Icons.trending_up,
            currency: false,
            value: data['fastestMovingProduct'] != null
                ? data['fastestMovingProduct']['title']
                : '0',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          InfoCard(
            title: ' Slow-Moving ',
            icon: Icons.trending_up,
            currency: false,
            value: data['slowestMovingProduct'] != null
                ? data['slowestMovingProduct']['title']
                : '0',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ]);
  }
}
