import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:invease/services/api.service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../components/charts/line_chart.dart';
import '../../../components/charts/range.dart';
import '../../../components/info_card.dart';
import '../../../components/tables/purchases/purchases_table.dart';
import '../../../globals/dialog.dart';
import 'add_order.dart';
import 'header.dart';
import 'helpers/damaged_goods.dart';

@RoutePage()
class ProductDashboard extends StatefulWidget {
  final String? productId;

  const ProductDashboard({super.key, this.productId});

  @override
  ProductDashboardState createState() => ProductDashboardState();
}

class ProductDashboardState extends State<ProductDashboard> {
  ApiService apiService = ApiService();
  late String productId;
  late Map data;
  bool loading = true;
  bool loadingTable = true;
  late List purchases;
  DateTime? _fromDate = DateTime(2010, 1, 1);
  DateTime? _toDate = DateTime.now();
  dynamic rangeInfo;
  bool allowMultipleSelection = true;
  List returnedSelection = [];
  String selectedRange = 'Today';
  bool showDetails = false;

  String? searchFeild = 'createdAt';
  String? selectedStatus = '';
  String? selectedSupplier = '';
  List<Map> suppliers = [];
  Set supplierSet = <String>{};
  dynamic totalSales = 0;

  // Function(String?) onFieldChange;
  // Function(String?) onSupplierChange;
  // Function(String?) onSelectStatus;

  @override
  void initState() {
    if (widget.productId != null) {
      productId = widget.productId!;
    } else {
      productId = '6790e2c0541e66e2d3a41b7c';
    }

    getChartData('Today');
    getPurchases();
    getDashboardData();

    super.initState();
  }

  Future getDashboardData() async {
    final response =
        await apiService.getRequest('products/dashboard/$productId');
    setState(() {
      data = response.data;
      loading = false;
    });
  }

  Future getPurchases() async {
    setState(() {
      loading = true;
      loadingTable = true;
      supplierSet = {};
      suppliers = [];
    });
    final response = await apiService.getRequest(
        'purchases?filter={"productId":"$productId", "$searchFeild" : "","supplier":"$selectedSupplier", "status" : {"\$regex" : "${selectedStatus?.toLowerCase()}"}}&sort={"$searchFeild":-1}&startDate=$_fromDate&endDate=$_toDate');

    setState(() {
      totalSales = 0;
      purchases = response.data;
      response.data.forEach((element) {
        var total =
            element['sold'].fold(0, (sum, item) => sum + (item["amount"] ?? 0));
        totalSales += total;
      });

      for (var purchase in purchases) {
        final supplier = purchase['supplier'];
        if (!supplierSet.contains(supplier['_id'])) {
          supplierSet.add(supplier['_id']);
          suppliers.add({'_id': supplier['_id'], 'name': supplier['name']});
        }
      }

      if (!supplierSet.contains("")) {
        suppliers.insert(0, {'_id': '', 'name': 'All Suppliers'});
      }

      loading = false;
      loadingTable = false;
    });
  }

  Future getChartData(dateRange) async {
    final range = getDateRange(dateRange);
    setState(() {
      rangeInfo = range;
    });
    final response = await apiService.getRequest(
        'sales/getchart/$productId?filter={"sorter":"$dateRange"}&startDate=${range.startDate}&endDate=${range.endDate}');
    print(response);
    // setState(() {
    //   purchases = response.data;
    //   loadingTable = false;
    // });
  }

  handleDamagedGoods(Map<String, dynamic> data) async {
    final info = {'productId': productId, 'damagedGoods': data};
    await apiService.putRequest(
        'purchases/update/${returnedSelection[0]['_id']}', info);
    await getPurchases();
  }

  handleSelection(dynamic selected) {
    setState(() {
      returnedSelection = selected;
    });
  }

  handleRangeChange(String select, DateTime picked) async {
    setState(() {
      loadingTable = true;
    });
    if (select == 'from') {
      setState(() {
        _fromDate = picked;
      });
    } else if (select == 'to') {
      setState(() {
        _toDate = picked;
      });
    }

    await getPurchases();
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
          // title: Text('${widget.product?['title']} Dashboard'),
          title: Text(' Dashboard'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    showDetails = !showDetails;
                  });
                },
                icon: AnimatedRotation(
                  turns: showDetails ? 0.5 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down),
                )),
            IconButton(
                tooltip: 'Add Order',
                onPressed: () => showBarModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddOrder(productId: productId),
                    ),
                icon: Icon(Icons.add_box_outlined)),
            IconButton(
              onPressed: () {
                openBox(context);
              },
              icon: Icon(Icons.delete_outline),
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
                      builder: (context) => AddOrder(productId: productId),
                    ),
                child: Icon(Icons.add_outlined)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                AnimatedContainer(
                  width: double.infinity,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  height: showDetails ? 200 : 0,
                  child: Column(
                    children: [
                      ProductHeader(
                        selectedField: searchFeild,
                        dateRangeHolder: dateRangeHolder,
                        selectedSupplier: selectedSupplier,
                        selectedStatus: selectedStatus,
                        onFieldChange: (value) {
                          setState(() {
                            searchFeild = value;
                          });
                        },
                        onSupplierChange: (value) {
                          setState(() {
                            selectedSupplier = value;
                          });
                          getPurchases();
                        },
                        onSelectStatus: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                          getPurchases();
                        },
                        suppliers: suppliers,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                                'name': 'Sold',
                                'sortable': true,
                                'type': 'sold',
                                'field': 'sold'
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
                              },
                              {
                                'name': 'Actions',
                                'sortable': false,
                                'type': 'actions',
                                'field': 'Actions'
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
                              IconButton(
                                  onPressed: () {
                                    print(returnedSelection[0]['sold']);
                                    if (returnedSelection.isEmpty) {
                                      doAlerts('Please select an item first');
                                    } else if (returnedSelection[0]
                                            ['quantity'] ==
                                        getSold(returnedSelection[0]['sold'])) {
                                      doAlerts('This batch have been sold out');
                                    } else {
                                      showDamagedGoodsForm(
                                          context,
                                          handleDamagedGoods,
                                          (returnedSelection[0]['quantity'] -
                                              getSold(returnedSelection[0]
                                                  ['sold'])));
                                    }
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                            title: '',
                            range: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceBright,
                                  borderRadius: BorderRadius.circular(5)),
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

  num getSold(List sold) {
    return sold.fold(0, (sum, item) => sum + (item["amount"] ?? 0));
  }

  doAlerts(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        padding: EdgeInsets.all(16),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Container dateRangeHolder(BuildContext context, isBigScreen) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Row(
            children: [
              isBigScreen ? Text('From :') : SizedBox.shrink(),
              IconButton(
                icon: Icon(Icons.calendar_today),
                tooltip: 'From date',
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _fromDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: _toDate ?? DateTime.now(),
                  );
                  if (picked != null) {
                    handleRangeChange('from', picked);
                  }
                },
              ),
              Text(
                _fromDate != null
                    ? "${_fromDate!.toLocal()}".split(' ')[0]
                    : "From",
              ),
            ],
          ),
          SizedBox(width: 16),
          Row(
            children: [
              isBigScreen ? Text('To :') : SizedBox.shrink(),
              IconButton(
                icon: Icon(Icons.calendar_today),
                tooltip: 'To date',
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _toDate ?? DateTime.now(),
                    firstDate: _fromDate ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    handleRangeChange('to', picked);
                  }
                },
              ),
              Text(
                _toDate != null ? "${_toDate!.toLocal()}".split(' ')[0] : "To",
              ),
            ],
          ),
          Spacer(),
          isBigScreen
              ? OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now();
                      _toDate = DateTime.now();
                      // getSales();
                    });
                  },
                  child: Text('Reset'),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now();
                      _toDate = DateTime.now();
                      // getSales();
                    });
                  },
                  icon: Icon(Icons.cancel_outlined)),
        ],
      ),
    );
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
          value: totalSales.toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
            title: 'Total Orders',
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
            currency: true,
            value:
                data['profits'] < 0 ? 0.toString() : data['profits'].toString(),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(color: Colors.green, toY: 30)]),
              BarChartGroupData(
                  x: 2, barRods: [BarChartRodData(toY: 20, color: Colors.red)]),
              BarChartGroupData(
                  x: 3,
                  barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),
            ],
          ),
        ),
      ),
    );
  }
}
