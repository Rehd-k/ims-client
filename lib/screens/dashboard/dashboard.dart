import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';
import 'sections/customer_insight.dart';
import 'sections/financialsummary.dart';
import 'sections/inventorysummery.dart';
import 'sections/salesoverview.dart';
import 'sections/todo.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  final Function()? onResult;
  const DashboardScreen({super.key, this.onResult});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {
  bool loading = true;
  ApiService apiService = ApiService();
  final DateTime _fromDate = DateTime.now();
  final DateTime _toDate = DateTime.now();

  List dashboardInfo = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    try {
      final results = await Future.wait([
        fetchSalesOverview(),
        fetchBestSellingProducts(),
        fetchInventorySummary(),
        fetchCustomerInsight(),
        fetchFinancialSummary()
      ]);
      setState(() {
        dashboardInfo = results;
      });
    } catch (e) {
      // Handle errors here
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<Map> fetchSalesOverview() async {
    // Your API call for Sales Overview
    var salesInfo = await apiService.getRequest(
        'analytics/profit-and-loss?startDate=$_fromDate&endDate=$_toDate');

    return salesInfo.data;
  }

  Future<Map> fetchBestSellingProducts() async {
    // Your API call for Best Selling Products
    var bestSellingProducts =
        await apiService.getRequest('analytics/get-best-selling-products');
    return bestSellingProducts.data;
  }

  Future<Map> fetchInventorySummary() async {
    var data = await apiService.getRequest('analytics/inventory-summary');
    return data.data;
  }

  Future<void> fetchCustomerInsight() async {
    var data = await apiService.getRequest('analytics/customer-summary');
    return data.data;
  }

  Future<void> fetchFinancialSummary() async {
    var data = await apiService.getRequest('analytics/sales-data');
    return data.data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
        appBar: AppBar(
            title: SvgPicture.asset(
              'assets/vectors/logo.svg',
            ),
            actions: [...actions(context, themeNotifier, tokenNotifier)]),
        drawer: smallScreen
            ? Drawer(
                backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                child: SideBar(tokenNotifier: tokenNotifier))
            : null,
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Salesoverview(
                      totalSales: dashboardInfo[0]['totalRevenue'],
                      topSellingProducts: dashboardInfo[1],
                    ),
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(maxHeight: 400),
                      child: TodoTable(),
                    ),
                    SizedBox(height: 20),
                    Inventorysummery(data: dashboardInfo[2]),
                    SizedBox(height: 20),
                    CustomerInsight(data: dashboardInfo[3]),
                    SizedBox(height: 20),
                    Financialsummary(salesData: dashboardInfo[4]),
                    SizedBox(height: 20),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 5),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       Text(
                    //         'Powered by Vessel-Labs',
                    //         style: TextStyle(
                    //             fontSize: 14, fontWeight: FontWeight.w500),
                    //       ),
                    //       Text(
                    //         'Reserved @ ${DateTime.now().year}',
                    //         style: TextStyle(
                    //             fontSize: 14, fontWeight: FontWeight.w500),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ]),
                )),
      );
    });
  }
}
