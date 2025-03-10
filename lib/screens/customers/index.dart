import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import 'add_customer.dart';
import 'view_customer.dart';

@RoutePage()
class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  CustomerScreenState createState() => CustomerScreenState();
}

class CustomerScreenState extends State<CustomerScreen> {
  final GlobalKey<ViewCustomersState> _viewCustomerKey =
      GlobalKey<ViewCustomersState>();

  void updateCustomers() {
    _viewCustomerKey.currentState?.updateCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [...actions(themeNotifier, tokenNotifier)],
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
                        child: AddCustomer(updateCustomer: updateCustomers)),
                SizedBox(width: smallScreen ? 0 : 20),
                Expanded(
                    flex: 2,
                    child: ViewCustomers(
                        key: _viewCustomerKey, updateCustomer: updateCustomers))
              ],
            ),
          ));
    });
  }
}
