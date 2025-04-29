import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import 'add_supplier.dart';
import 'view_suppliers.dart';

@RoutePage()
class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  SupplierIndexState createState() => SupplierIndexState();
}

class SupplierIndexState extends State<SupplierScreen> {
  final GlobalKey<ViewSuppliersState> _viewSupplierKey =
      GlobalKey<ViewSuppliersState>();

  void updateSuppliers() {
    _viewSupplierKey.currentState?.updateSupplierList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [...actions(context, themeNotifier, tokenNotifier)],
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
                        child: AddSupplier(updateSupplier: updateSuppliers)),
                SizedBox(width: smallScreen ? 0 : 20),
                Expanded(
                    flex: 2,
                    child: ViewSuppliers(
                        key: _viewSupplierKey, updateSupplier: updateSuppliers))
              ],
            ),
          ));
    });
  }
}
