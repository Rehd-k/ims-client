import 'package:flutter/material.dart';

import '../../../components/info_card.dart';
import '../../../components/tables/smalltable/smalltable.dart';

class CustomerInsight extends StatelessWidget {
  final Map data;
  const CustomerInsight({super.key, required this.data});

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Align(
                  alignment:
                      isBigScreen ? Alignment.centerLeft : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(isBigScreen ? 8.0 : 4.0),
                    child: Text(
                      'Customer Insights',
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
                    height: isBigScreen ? 175 : 70,
                    child: grids(isBigScreen, context)),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 400,
                    ),
                    child: isBigScreen
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Top Customers',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      SmallTable(columns: [
                                        'Name',
                                        'Last Purchase Date',
                                        'Amount Spent',
                                        'Total Spent',
                                      ], rows: data['mostFrequentCustomer']),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'New Customers',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      SmallTable(columns: [
                                        'Name',
                                        'Last Purchase Date',
                                        'Amount Spent',
                                        'Total Spent',
                                      ], rows: data['newestCustomers']),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Top Customers',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SmallTable(columns: [
                                      'Name',
                                      'Last Purchase Date',
                                      'Amount Spent',
                                      'Total Spent',
                                    ], rows: data['newestCustomers']),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'New Customers',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SmallTable(columns: [
                                      'Name',
                                      'Last Purchase Date',
                                      'Amount Spent',
                                      'Total Spent',
                                    ], rows: data['mostFrequentCustomer']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
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
            title: 'Total Customers',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['totalCustomers'].isNotEmpty
                ? data['totalCustomers'][0]['totalCustomers'].toString()
                : '0',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          ),
          InfoCard(
            title: 'Customer Retention',
            icon: Icons.trending_up,
            currency: false,
            value: data['retentionCurrentMonth'].isNotEmpty
                ? data['retentionCurrentMonth'][0]['customerRetention']
                    .toString()
                : '0',
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface,
          )
        ]);
  }
}
