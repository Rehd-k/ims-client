import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:invease/services/api.service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../components/charts/line_chart.dart';
import '../../../components/charts/range.dart';
import '../../../components/info_card.dart';
import '../../../components/tables/purchases/purchases_table.dart';
import 'add_order.dart';

@RoutePage()
class ProductDashboard extends StatefulWidget {
  final Map product;

  const ProductDashboard({super.key, required this.product});

  @override
  ProductDashboardState createState() => ProductDashboardState();
}

class ProductDashboardState extends State<ProductDashboard> {
  ApiService apiService = ApiService();
  late Map product;
  late Map data;
  bool loading = true;
  bool loadingTable = true;
  late List purchases;
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  dynamic rangeInfo;
  bool allowMultipleSelection = true;
  dynamic returnedSelection;
  String selectedRange = 'Today';

  @override
  void initState() {
    product = widget.product;
    getChartData('Today');
    getPurchases();
    getDashboardData();

    super.initState();
  }

  Future getDashboardData() async {
    final response = await apiService
        .getRequest('products/dashboard/${product['productId']}');
    setState(() {
      data = response.data;
      loading = false;
    });
  }

  Future getPurchases() async {
    final response = await apiService.getRequest(
        'purchases?filter={"productId":"${product['productId']}"}&sort={"createdAt":-1}&startDate=2024-01-01&endDate=2025-12-31');
    setState(() {
      purchases = response.data;
      loadingTable = false;
    });
  }

  Future getChartData(dateRange) async {
    final range = getDateRange(dateRange);
    setState(() {
      rangeInfo = range;
    });
    final response = await apiService.getRequest(
        'sales/getchart/${product['productId']}?filter={"sorter":"$dateRange"}&startDate=${range.startDate}&endDate=${range.endDate}');
    print(response);
    // setState(() {
    //   purchases = response.data;
    //   loadingTable = false;
    // });
  }

  handleSelection(dynamic selected) {
    setState(() {
      returnedSelection = selected;
    });
  }

  handleRangeChanged(String rangeLabel) {
    setState(() {
      selectedRange = rangeLabel;
    });
    getChartData(selectedRange);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.router.back();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text('${widget.product['title']} Dashboard'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            )
          ],
        ),
        floatingActionButton: isBigScreen
            ? null
            : FloatingActionButton(
                tooltip: 'Make an Order',
                onPressed: () => showBarModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          AddOrder(productId: product['productId']),
                    ),
                child: Icon(Icons.add_outlined)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(
                    width: double.infinity,
                    height: isBigScreen ? 450 : 900,
                    child: loading
                        ? Center(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator()))
                        : cardsInfo(isBigScreen, data)),
                SizedBox(height: 16),
                Container(
                    height: isBigScreen ? 600 : 900,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: isBigScreen
                        ? Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Card(
                                    elevation: 3,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: LineChartSample1(
                                      onRangeChanged: handleRangeChanged,
                                      rangeInfo: rangeInfo,
                                      selectedRange: selectedRange,
                                    ),
                                  )),
                              SizedBox(width: 5),
                              Expanded(flex: 2, child: ProductCategoryChart()),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                  child: Card(
                                elevation: 3,
                                color: Theme.of(context).colorScheme.surface,
                                child: LineChartSample1(
                                  onRangeChanged: handleRangeChanged,
                                  rangeInfo: rangeInfo,
                                  selectedRange: selectedRange,
                                ),
                              )),
                              SizedBox(height: 50),
                              Expanded(child: ProductCategoryChart()),
                            ],
                          )),
                SizedBox(height: 16),
                SizedBox(
                    height: 600,
                    child: loadingTable
                        ? SizedBox()
                        : MainTable(
                            showCheckboxColumn: false,
                            isLoading: loadingTable,
                            data: purchases,
                            columnDefs: [
                              {
                                'name': 'Quantity',
                                'sortable': true,
                                'type': 'number',
                                'field': 'quantity'
                              },
                              {
                                'name': 'Price',
                                'sortable': true,
                                'type': 'money',
                                'field': 'price'
                              },
                              {
                                'name': 'Total',
                                'sortable': true,
                                'type': 'money',
                                'field': 'total'
                              },
                              {
                                'name': 'Discount',
                                'sortable': true,
                                'type': 'money',
                                'field': 'discount'
                              },
                              {
                                'name': 'Total Payable',
                                'sortable': true,
                                'type': 'money',
                                'field': 'totalPayable'
                              },
                              {
                                'name': 'Purchase Date',
                                'sortable': false,
                                'type': 'date',
                                'field': 'purchaseDate'
                              },
                              {
                                'name': 'Status',
                                'sortable': false,
                                'type': 'text',
                                'field': 'status'
                              },
                              {
                                'name': 'Delivery Date',
                                'sortable': true,
                                'type': 'date',
                                'field': 'deliveryDate'
                              },
                              {
                                'name': 'Expiry Date',
                                'sortable': true,
                                'type': 'date',
                                'field': 'expiryDate'
                              },
                              {
                                'name': 'Cash',
                                'sortable': false,
                                'type': 'money',
                                'field': 'cash'
                              },
                              {
                                'name': 'Transfer',
                                'sortable': false,
                                'type': 'money',
                                'field': 'transfer'
                              },
                              {
                                'name': 'Card',
                                'sortable': false,
                                'type': 'money',
                                'field': 'card'
                              },
                              {
                                'name': 'Initiator',
                                'sortable': false,
                                'type': 'text',
                                'field': 'initiator'
                              },
                              {
                                'name': 'Date',
                                'sortable': true,
                                'type': 'date',
                                'field': 'createdAt'
                              }
                            ],
                            sortableColumns: {
                              0: 'quantity',
                              1: 'price',
                              2: 'total',
                              3: 'discount',
                              4: 'totalPayable',
                              5: 'purchaseDate',
                              6: 'createdAt'
                            },
                            actions: [
                              isBigScreen
                                  ? FilledButton(
                                      onPressed: () => showBarModalBottomSheet(
                                            expand: true,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => AddOrder(
                                                productId: widget
                                                    .product['productId']),
                                          ),
                                      child: Text('Add Order'))
                                  : SizedBox(),
                              PopupMenuButton(
                                  icon: Icon(Icons.filter_alt_outlined),
                                  tooltip: 'filter',
                                  itemBuilder: (BuildContext _) {
                                    return const [
                                      PopupMenuItem(
                                        value: '/hello',
                                        child: Text("Hello"),
                                      ),
                                      PopupMenuItem(
                                        value: '/about',
                                        child: Text("About"),
                                      ),
                                      PopupMenuItem(
                                        value: '/contact',
                                        child: Text("Contact"),
                                      )
                                    ];
                                  }),
                            ],
                            title: '',
                            range: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        tooltip: 'From date',
                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _fromDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: _toDate ?? DateTime.now(),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _fromDate = picked;
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                        _fromDate != null
                                            ? "${_fromDate!.toLocal()}"
                                                .split(' ')[0]
                                            : "From",
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 16),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        tooltip: 'To date',
                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _toDate ?? DateTime.now(),
                                            firstDate:
                                                _fromDate ?? DateTime(2000),
                                            lastDate: DateTime.now(),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _toDate = picked;
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                        _toDate != null
                                            ? "${_toDate!.toLocal()}"
                                                .split(' ')[0]
                                            : "To",
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _fromDate = null;
                                        _toDate = null;
                                      });
                                    },
                                    child: Text('Reset'),
                                  ),
                                ],
                              ),
                            ),
                            allowMultipleSelection: false,
                            returnSelection: handleSelection,
                            longPress: false,
                          ))
              ])),
        ));
  }

  GridView cardsInfo(bool isBigScreen, Map data) {
    return GridView.count(
      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      primary: true,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: isBigScreen ? 3 : 2,
      childAspectRatio: 3,
      children: [
        InfoCard(
          title: 'Total Sales',
          icon: Icons.payments_outlined,
          currency: false,
          value: '3000000000'.toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
            title: 'Total Purchases',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['total_purchases'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Total Purchases',
            icon: Icons.payments_outlined,
            currency: true,
            value: data['total_purchases'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Total Revenue',
            icon: Icons.payments_outlined,
            currency: true,
            value: data['total_sales_value'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Profit Margin',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['profits'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Quanitity at Store',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['quanity'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Expired',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['expired_goods'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
        InfoCard(
            title: 'Damaged',
            icon: Icons.payments_outlined,
            currency: false,
            value: data['damaged_goods'].toString(),
            fontSize: isBigScreen ? 20 : 10,
            color: Theme.of(context).colorScheme.surface),
      ],
    );
  }
}

class ProductCategoryChart extends StatelessWidget {
  const ProductCategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.surface,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
                x: 1, barRods: [BarChartRodData(color: Colors.green, toY: 30)]),
            BarChartGroupData(
                x: 2, barRods: [BarChartRodData(toY: 20, color: Colors.red)]),
            BarChartGroupData(
                x: 3, barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),
          ],
        ),
      ),
    );
  }
}
