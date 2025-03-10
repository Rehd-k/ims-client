import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invease/globals/actions.dart';
import 'package:invease/screens/products/category/add_category.dart';
import 'package:invease/screens/products/category/view_category.dart';
import 'package:provider/provider.dart';

import '../../../globals/sidebar.dart';
import '../../../helpers/providers/theme_notifier.dart';
import '../../../helpers/providers/token_provider.dart';

@RoutePage()
class CategoryIndex extends StatefulWidget {
  const CategoryIndex({super.key});

  @override
  CategoryIndexState createState() => CategoryIndexState();
}

class CategoryIndexState extends State<CategoryIndex> {
  final GlobalKey<ViewCategoryState> _viewProductKey =
      GlobalKey<ViewCategoryState>();

  void updateCategories() {
    _viewProductKey.currentState?.updateCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<TokenNotifier, ThemeNotifier>(
        builder: (context, tokenNotifier, themeNotifier, child) {
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
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              smallScreen
                  ? SizedBox.shrink()
                  : Expanded(
                      flex: 1,
                      child: AddCategory(updateCategory: updateCategories)),
              SizedBox(width: smallScreen ? 0 : 20),
              Expanded(
                  flex: 2,
                  child: ViewCategory(
                      key: _viewProductKey, updateCategory: updateCategories))
            ],
          ));
    });
  }
}
