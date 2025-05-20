import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import 'add_products.dart';
import 'view_products.dart';

@RoutePage()
class ProductsIndex extends StatefulWidget {
  const ProductsIndex({super.key});

  @override
  ProductsIndexState createState() => ProductsIndexState();
}

class ProductsIndexState extends State<ProductsIndex> {
  final GlobalKey<ViewProductsState> _viewProductKey =
      GlobalKey<ViewProductsState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<TokenNotifier, ThemeNotifier>(
        builder: (context, tokenNotifier, themeNotifier, child) {
      return Scaffold(
          floatingActionButton: smallScreen
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        // height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.all(8.0),
                        child: AddProducts(
                          tokenNotifier: tokenNotifier,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.add_outlined))
              : null,
          appBar: AppBar(
            actions: [
              tokenNotifier.decodedToken!['role'] == 'cashier'
                  ? SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 1,
                            padding: const EdgeInsets.all(8.0),
                            child: AddProducts(
                              tokenNotifier: tokenNotifier,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_outlined)),
              ...actions(context, themeNotifier, tokenNotifier)
            ],
          ),
          drawer: smallScreen
              ? Drawer(
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  child: SideBar(tokenNotifier: tokenNotifier))
              : null,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              smallScreen
                  ? SizedBox.shrink()
                  : tokenNotifier.decodedToken?['role'] != 'cashier'
                      ? Expanded(
                          flex: 1,
                          child: AddProducts(
                            tokenNotifier: tokenNotifier,
                          ))
                      : SizedBox.shrink(),
              SizedBox(width: smallScreen ? 0 : 20),
              Expanded(
                  flex:
                      tokenNotifier.decodedToken?['role'] == 'cashier' ? 1 : 2,
                  child: ViewProducts(
                      key: _viewProductKey, tokenNotifier: tokenNotifier))
            ],
          ));
    });
  }
}
