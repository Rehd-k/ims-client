import 'package:flutter/material.dart';

import '../../../components/info_card.dart';

class Inventorysummery extends StatelessWidget {
  const Inventorysummery({super.key});

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
              color: Theme.of(context).cardColor,
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
                    height: isBigScreen ? 350 : 175,
                    child: grids(isBigScreen, context)),
                SizedBox(height: 5),
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
            title: 'Total Stock Value',
            icon: Icons.payments_outlined,
            currency: true,
            value: '3000000',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
          InfoCard(
            title: 'Low Stock',
            icon: Icons.trending_up,
            currency: true,
            value: '3000000',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.error.withAlpha(200),
          ),
          InfoCard(
            title: 'Expired/Expiring',
            icon: Icons.trending_up,
            currency: true,
            value: '3000000',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.error,
          ),
          InfoCard(
            title: 'Fast-Moving',
            icon: Icons.trending_up,
            currency: true,
            value: '3000000',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
          InfoCard(
            title: ' Slow-Moving ',
            icon: Icons.trending_up,
            currency: true,
            value: '3000000',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
        ]);
  }
}
