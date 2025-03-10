import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invease/helpers/providers/token_provider.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import 'sections/customer_insight.dart';
import 'sections/financialsummary.dart';
import 'sections/inventorysummery.dart';
import 'sections/salesoverview.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  final Function()? onResult;
  const DashboardScreen({super.key, this.onResult});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
        appBar: AppBar(actions: [...actions(themeNotifier, tokenNotifier)]),
        drawer: Drawer(
            backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
            child: SideBar(tokenNotifier: tokenNotifier)),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Salesoverview(),
                SizedBox(height: 20),
                Inventorysummery(),
                SizedBox(height: 20),
                CustomerInsight(),
                SizedBox(height: 20),
                Financialsummary()
              ]),
            )),
      );
    });
  }
}
