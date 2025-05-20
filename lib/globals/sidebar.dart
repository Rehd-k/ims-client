import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/providers/token_provider.dart';

List fullMenu = [
  {
    'icon': Icons.dashboard_outlined,
    'title': 'Dashboard',
    'link': '/dashboard'
  },
  {
    'icon': Icons.people_alt_outlined,
    'title': 'Administrator',
    'link': '/administrator',
    'children': [
      {'title': 'Users', 'link': '/users', 'icon': Icons.emoji_people_outlined},
      {'title': 'Banks', 'link': '/banks', 'icon': Icons.business_outlined},
      {'title': 'Locations', 'link': '/location', 'icon': Icons.place_outlined},
      {
        'title': 'Charges',
        'link': '/charges',
        'icon': Icons.fullscreen_exit_sharp
      }
    ]
  },
  {
    'icon': Icons.inventory_2_outlined,
    'title': 'Products',
    'children': [
      {
        'title': 'Product List',
        'link': '/products',
        'icon': Icons.subject_outlined
      },
      {
        'title': 'Category',
        'link': '/categories',
        'icon': Icons.category_outlined
      }
    ]
  },
  {
    'icon': Icons.perm_identity_outlined,
    'title': 'Customers',
    'link': '/customers'
  },
  {
    'icon': Icons.local_shipping_outlined,
    'title': 'Suppliers',
    'link': '/suppliers'
  },
  {
    'icon': Icons.bar_chart_outlined,
    'title': 'Reports',
    'link': '/report',
    'children': [
      // {
      //   'title': 'Payment Report',
      //   'link': '/payment_report',
      //   'icon': Icons.receipt_long_outlined
      // },
      {
        'title': 'Income Report',
        'link': '/income_report',
        'icon': Icons.checklist_outlined
      }
      // {
      //   'title': 'Expenses Report',
      //   'link': '/expenses_report',
      //   'icon': Icons.request_quote_outlined
      // }
    ]
  },
  {
    'icon': Icons.receipt_long_outlined,
    'title': 'Invoices',
    'link': '/invoice',
    'children': [
      {
        'title': 'Add Invoice',
        'link': '/create_invoice',
        'icon': Icons.add_outlined
      },
      {
        'title': 'Invoices',
        'link': '/view_invoices',
        'icon': Icons.more_vert_outlined
      }
      // {
      //   'title': 'Recurring Invoices',
      //   'link': '/recurring_invoices',
      //   'icon': Icons.request_quote_outlined
      // }
    ]
  },
  {
    'icon': Icons.point_of_sale_outlined,
    'title': 'Make Sale',
    'link': '/make-sale',
  },
  {
    'icon': Icons.dynamic_feed_outlined,
    'title': 'Expenses',
    'link': '/expenses',
  },
];
List cashierMenu = [
  {
    'icon': Icons.inventory_2_outlined,
    'title': 'Products',
    'link': '/products',
  },
  {
    'icon': Icons.point_of_sale_outlined,
    'title': 'Make Sale',
    'link': '/make-sale',
  },
  {
    'icon': Icons.perm_identity_outlined,
    'title': 'Customers',
    'link': '/customers'
  },
  {
    'icon': Icons.local_shipping_outlined,
    'title': 'Suppliers',
    'link': '/suppliers'
  },
  {
    'icon': Icons.bar_chart_outlined,
    'title': 'Sales',
    'link': '/income_report',
  }
];

class SideBar extends StatefulWidget {
  final TokenNotifier tokenNotifier;

  const SideBar({super.key, required this.tokenNotifier});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  late List<bool> expandedStates;
  List menuData = [];

  @override
  void initState() {
    super.initState();
    if (widget.tokenNotifier.decodedToken?['role'] == 'admin') {
      menuData = fullMenu;
    } else if (widget.tokenNotifier.decodedToken?['role'] == 'cashier') {
      menuData = cashierMenu;
    }
    expandedStates = List.filled(menuData.length, false);
  }

  void expand(int index) {
    setState(() {
      expandedStates[index] = !expandedStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tokenNotifier.decodedToken?['username'] != null) {
      return Column(children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SvgPicture.asset(
              'assets/vectors/logo.svg',
              height: 40,
              width: 40,
            ),
            Text('SHELF SENSE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary)),
          ]),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: menuData.length,
              itemBuilder: (context, index) {
                final item = menuData[index];
                bool hasChildren = item['children'] != null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () => hasChildren
                          ? expand(index)
                          : context.router.pushPath(item['link']),
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withAlpha(25),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(
                                        item['icon'],
                                        size: 15,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Text(
                                      item['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                hasChildren
                                    ? Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Icon(
                                          size: 14,
                                          expandedStates[index]
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_right,
                                          color: Colors.blueGrey,
                                        ),
                                      )
                                    : SizedBox.shrink()
                              ])),
                    ),
                    AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: expandedStates[index]
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: item['children']
                                      .map<Widget>(
                                        (child) => InkWell(
                                          onTap: () => context.router
                                              .pushPath(child['link']),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 0, 20),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Icon(
                                                  child['icon'],
                                                  size: 15,
                                                  color: Colors.blueGrey,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: Text(
                                                    child['title'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            : SizedBox.shrink())
                  ],
                );
              }),
        ),
      ]);
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
