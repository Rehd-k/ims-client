import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../globals/actions.dart';
import '../globals/sidebar.dart';
import '../helpers/providers/theme_notifier.dart';
import '../helpers/providers/token_provider.dart';

@RoutePage()
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  MainMenuScreenState createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  late Map? userData;
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
        {
          'title': 'Users',
          'link': '/users',
          'icon': Icons.emoji_people_outlined
        },
        {'title': 'Roles', 'link': '/roles', 'icon': Icons.shield_outlined},
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
        {
          'title': 'Payment Report',
          'link': '/payment_report',
          'icon': Icons.receipt_long_outlined
        },
        {
          'title': 'Income Report',
          'link': '/income_report',
          'icon': Icons.checklist_outlined
        },
        {
          'title': 'Expenses Report',
          'link': '/expenses_report',
          'icon': Icons.request_quote_outlined
        }
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

  List menuData = [];

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

  late List<bool> expandedStates;

  void _fetchUserData() {
    final tokenProvider = context.read<TokenNotifier>(); // Get provider
    userData = tokenProvider.decodedToken; // Fetch data
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    if (userData?['role'] == 'admin') {
      menuData = fullMenu;
    } else if (userData?['role'] == 'cashier') {
      menuData = cashierMenu;
    }
    expandedStates = List.filled(menuData.length, false);
  }

  void expand(index) {
    setState(() {
      expandedStates[index] = !expandedStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          // appBar: AppBar(
          //   title: const Text('AppBar with hamburger button'),
          //   leading: !smallScreen
          //       ? null
          //       : Builder(
          //           builder: (context) {
          //             return IconButton(
          //               icon: const Icon(Icons.menu),
          //               onPressed: () {
          //                 Scaffold.of(context).openDrawer();
          //               },
          //             );
          //           },
          //         ),
          // ),
          // drawer: Drawer(
          //   backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          //   child: sideBar(
          //       context, menuData,  tokenNotifier),
          // ),
          body: Row(
        children: [
          !smallScreen
              ? Expanded(
                  flex: 1,
                  child: Container(
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: SideBar(tokenNotifier: tokenNotifier)))
              : Container(),
          Expanded(flex: 5, child: AutoRouter())
        ],
      ));
    });
  }
}
