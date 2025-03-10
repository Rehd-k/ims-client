import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invease/globals/actions.dart';
import 'package:provider/provider.dart';

import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';

@RoutePage()
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<TokenNotifier, ThemeNotifier>(
        builder: (context, tokenNotifier, themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(actions: [...actions(themeNotifier, tokenNotifier)]),
        drawer: smallScreen
            ? Drawer(
                backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                child: SideBar(tokenNotifier: tokenNotifier))
            : null,
      );
    });
  }
}
