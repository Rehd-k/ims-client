import 'package:flutter/material.dart';

import '../../../components/info_card.dart';
import '../../../components/tables/smalltable/smalltable.dart';

class CustomerInsight extends StatelessWidget {
  const CustomerInsight({super.key});

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
                                          'Customer Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      SmallTable(
                                        columns: [
                                          'Name',
                                          'Last Purchase Date',
                                          'Amount Spent',
                                          'Total Spent',
                                        ],
                                        rows: [
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                        ],
                                      ),
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
                                          'Customer Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      SmallTable(
                                        columns: [
                                          'Name',
                                          'Last Purchase Date',
                                          'Amount Spent',
                                          'Total Spent',
                                        ],
                                        rows: [
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'John Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                          [
                                            'Jane Doe',
                                            '12/12/2020',
                                            '2000',
                                            '20000'
                                          ],
                                        ],
                                      ),
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
                                        'Customer Details',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SmallTable(
                                      columns: [
                                        'Name',
                                        'Last Purchase Date',
                                        'Amount Spent',
                                        'Total Spent',
                                      ],
                                      rows: [
                                        [
                                          'John Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'Jane Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'John Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'Jane Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ]
                                      ],
                                    ),
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
                                        'Customer Details',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SmallTable(
                                      columns: [
                                        'Name',
                                        'Last Purchase Date',
                                        'Amount Spent',
                                        'Total Spent',
                                      ],
                                      rows: [
                                        [
                                          'John Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'Jane Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'John Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ],
                                        [
                                          'Jane Doe',
                                          '12/12/2020',
                                          '2000',
                                          '20000'
                                        ]
                                      ],
                                    ),
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
          )
        ]);
  }
}
