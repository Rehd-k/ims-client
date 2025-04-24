import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import 'add_expneses.dart';
import 'view_expenses.dart';

@RoutePage()
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  final GlobalKey<ViewExpensesState> viewExpenseKey =
      GlobalKey<ViewExpensesState>();

  void updateExpenses() {
    viewExpenseKey.currentState?.updateExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              FilledButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.exit_to_app,
                  size: 10,
                ),
                label: Text(
                  'Extract',
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10),
                ),
              ),
              ...actions(context, themeNotifier, tokenNotifier)
            ],
          ),
          drawer: smallScreen
              ? Drawer(
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  child: SideBar(tokenNotifier: tokenNotifier))
              : null,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallScreen
                    ? SizedBox.shrink()
                    : Expanded(
                        flex: 1,
                        child: AddExpenses(updateExpenses: updateExpenses)),
                SizedBox(width: smallScreen ? 0 : 20),
                Expanded(
                    flex: 2,
                    child: ViewExpenses(
                        key: viewExpenseKey, updateExpense: updateExpenses))
              ],
            ),
          ));
    });
  }
}
