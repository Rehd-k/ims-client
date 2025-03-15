import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invease/helpers/providers/token_provider.dart';
import 'package:invease/services/api.service.dart';
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
  ApiService apiService = ApiService();

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

      // Process results here if needed
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
        'analytics/profit-and-loss?startDate=${DateTime.now().toIso8601String()}&endDate=${DateTime.now().toIso8601String()}');

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
    // Your API call for Financial Summary
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
        appBar: AppBar(actions: [...actions(themeNotifier, tokenNotifier)]),
        drawer: Drawer(
            backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
            child: SideBar(tokenNotifier: tokenNotifier)),
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
                    Inventorysummery(data: dashboardInfo[2]),
                    SizedBox(height: 20),
                    CustomerInsight(data: dashboardInfo[3]),
                    SizedBox(height: 20),
                    Financialsummary()
                  ]),
                )),
      );
    });
  }
}
