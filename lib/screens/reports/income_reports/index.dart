import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/info_card.dart';
import '../../../components/tables/purchases/purchases_table.dart';
import '../../../globals/actions.dart';
import '../../../globals/sidebar.dart';

import '../../../helpers/providers/theme_notifier.dart';
import '../../../helpers/providers/token_provider.dart';
import '../../../services/api.service.dart';
import 'header.dart';
import 'more_details.dart';

@RoutePage()
class IncomeReportsScreen extends StatefulWidget {
  const IncomeReportsScreen({super.key});

  @override
  IncomeReportsScreenState createState() => IncomeReportsScreenState();
}

class IncomeReportsScreenState extends State<IncomeReportsScreen> {
  final apiService = ApiService();
  List filteredsales = [];
  bool loadingTable = true;
  bool loading = true;
  final TextEditingController _searchController = TextEditingController();
  late List sales = [];
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  String searchQuery = "";
  bool allowMultipleSelection = false;
  List selectedItem = [];
  List selectedItems = [];
  bool showDetails = false;
  Map<String, dynamic> transactionUpdate = {};
  String? searchFeild = 'transactionId';
  String? searchFeildForSearchText = '';
  String? paymentMethordToShow = '';
  String? selectedAccount = '';
  List cashiers = [''];

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  // Search logic
  void searchThroughSales(String query) async {
    if (query.isEmpty) return;

    // Debounce logic
    Future.delayed(Duration(milliseconds: 300), () {
      if (query == _searchController.text) {
        setState(() {
          loadingTable = true;
        });
        // Only proceed if the query hasn't changed during the debounce period
        apiService
            .getRequest(
          'sales?filter={"$searchFeild" : {"\$regex" : "${query.toLowerCase()}"}}&limit=0&sort={"transactionDate":-1}&startDate=$_fromDate&endDate=$_toDate',
        )
            .then((dbsales) {
          updateFilter(dbsales);
        });
      }
    });
    var dbsales = await apiService.getRequest(
      'sales?filter={"$searchFeild" : {"\$regex" : "${query.toLowerCase()}"}}&limit=0&sort={"transactionDate":-1}&startDate=$_fromDate&endDate=$_toDate',
    );
    updateFilter(dbsales);
  }

  // filter logic
  void filterLogic(String searchFeild, String? query) async {
    setState(() {
      loadingTable = true;
    });
    var dbsales = await apiService.getRequest(
      'sales?filter={"$searchFeild" : {"\$regex" : "${query?.toLowerCase()}"}}&limit=0&sort={"transactionDate":-1}&startDate=$_fromDate&endDate=$_toDate',
    );
    updateFilter(dbsales);
  }

  void updateTransaction() async {
    final userRole = context.read<TokenNotifier>().decodedToken;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (userRole != null) {
      if (userRole['role'] == 'admin' || userRole['role'] == 'god') {
        await apiService.putRequest(
            'sales/${selectedItem[0]['_id']}', transactionUpdate);
        getSales();
      } else {
        await apiService.postRequest('todo', {
          'title': 'Back Date',
          'description':
              'Change the date of transaction with Id  ${selectedItem[0]['transactionId']} to ${formatDate(transactionUpdate['transactionDate'])}',
          'from': userRole['username'],
        });

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                'A request has been sent to the Manager, and will be effected soon'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  handleUpdate(updateInfo) {
    setState(() {
      transactionUpdate = updateInfo;
      updateTransaction();
    });
    // Check if widget is still mounted before showing message
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Use captured scaffoldMessenger
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Updated'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  handleSelection(dynamic selected) {
    setState(() {
      selectedItem = [];
      if (allowMultipleSelection) {
        for (var i = 0; i < selected.length; i++) {
          selectedItems.add(selected[i]);
        }
      } else {
        if (selected.isNotEmpty) {
          selectedItem = selected;
        } else {
          selectedItem = [];
        }
      }
    });

    if (selectedItem.isNotEmpty && MediaQuery.of(context).size.width < 600) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height *
                  0.95, // Almost full screen
              padding: EdgeInsets.all(16),
              child: ShowDetails(
                  dataList: selectedItem,
                  handleUpdate: handleUpdate,
                  updatePageInfo: updatePageInfo));
        },
      );
    }
  }

  Future getSales() async {
    setState(() {
      loadingTable = true;
    });
    var dbsales = await apiService.getRequest(
      'sales?limit=0&sort={"transactionDate":-1}&startDate=$_fromDate&endDate=$_toDate',
    );
    updateFilter(dbsales);
  }

  void updatePageInfo() async {
    var dbsales = await apiService.getRequest(
      'sales?limit=0&sort={"transactionDate":-1}&startDate=$_fromDate&endDate=$_toDate',
    );
    updateFilter(dbsales);
  }

  List getFilteredAndSortedRows() {
    List filteredsales = sales.where((product) {
      return product.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return filteredsales;
  }

  handleRangeChange(String select, DateTime picked) async {
    if (select == 'from') {
      setState(() {
        _fromDate = picked;
      });
    } else if (select == 'to') {
      setState(() {
        _toDate = picked;
      });
    }

    await getSales();
  }

  updateFilter(dbsales) {
    setState(() {
      sales = dbsales.data['sales'];
      filteredsales = List.from(sales);
      cashiers = dbsales.data['handlers'];
      if (cashiers.isEmpty) {
        selectedAccount = '';
      }
      cashiers.insert(0, '');

      loadingTable = false;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSales();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;

    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          appBar: AppBar(actions: [
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
            ...actions(context, themeNotifier, tokenNotifier)
          ]),
          drawer: isBigScreen
              ? null
              : Drawer(
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  child: SideBar(tokenNotifier: tokenNotifier)),
          body: Padding(
            padding: EdgeInsets.all(isBigScreen ? 8.0 : 4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    width: double.infinity,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    height: showDetails ? 250 : 0,
                    child: Column(
                      children: [
                        IncomeReportsHeader(
                          selectedField: searchFeild,
                          selectedPaymentMethod: paymentMethordToShow,
                          selectedAccount: selectedAccount,
                          isSearchEnabled: true,
                          searchController: _searchController,
                          onFieldChange: (value) {
                            setState(() {
                              searchFeild = value;
                              searchFeildForSearchText = value;
                            });
                          },
                          onAccountChange: (value) {
                            filterLogic('handler', value);
                            setState(() {
                              selectedAccount = value;
                            });
                          },
                          onPaymentMethodChange: (value) {
                            setState(() {
                              paymentMethordToShow = value;
                              filterLogic('paymentMethod', value);
                            });
                          },
                          onSearcfieldChange: (value) {
                            searchThroughSales(value);
                          },
                          cashiers: cashiers,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: isBigScreen
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            isBigScreen
                                ? SizedBox(
                                    width: isBigScreen
                                        ? MediaQuery.of(context).size.width / 2
                                        : MediaQuery.of(context).size.width,
                                    child:
                                        dateRangeHolder(context, isBigScreen),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      width: isBigScreen
                                          ? MediaQuery.of(context).size.width /
                                              2
                                          : MediaQuery.of(context).size.width,
                                      child:
                                          dateRangeHolder(context, isBigScreen),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: isBigScreen ? 450 : 400,
                      child: loading
                          ? Center(
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator()))
                          : cardsInfo(isBigScreen, handleCalculations())),
                  loadingTable
                      ? SizedBox.shrink()
                      : Row(children: [
                          Expanded(
                            child: MainTable(
                              showCheckboxColumn: true,
                              isLoading: loadingTable,
                              data: filteredsales,
                              columnDefs: [
                                {
                                  'name': 'Trans Id',
                                  'sortable': false,
                                  'type': 'uppercase',
                                  'field': 'transactionId'
                                },
                                {
                                  'name': 'Cash',
                                  'sortable': true,
                                  'type': 'money',
                                  'field': 'cash'
                                },
                                {
                                  'name': 'Card',
                                  'sortable': true,
                                  'type': 'money',
                                  'field': 'card'
                                },
                                {
                                  'name': 'Transfer',
                                  'sortable': true,
                                  'type': 'money',
                                  'field': 'transfer'
                                },
                                {
                                  'name': 'Discount',
                                  'sortable': false,
                                  'type': 'money',
                                  'field': 'discount'
                                },
                                {
                                  'name': 'Total',
                                  'sortable': true,
                                  'type': 'money',
                                  'field': 'totalAmount'
                                },
                                {
                                  'name': 'Date',
                                  'sortable': true,
                                  'type': 'date',
                                  'field': 'createdAt'
                                },
                                {
                                  'name': 'Initiator',
                                  'sortable': false,
                                  'type': 'text',
                                  'field': 'handler'
                                }
                              ],
                              sortableColumns: {
                                0: 'quantity',
                                1: 'totalAmount',
                                2: 'createdAt',
                              },
                              actions: [
                                PopupMenuButton(
                                    onSelected: (value) => {},
                                    icon: Icon(Icons.filter_alt_outlined),
                                    tooltip: 'Payment Method',
                                    itemBuilder: (BuildContext _) {
                                      return const [
                                        PopupMenuItem(
                                          value: 'cash',
                                          child: Text("Cash"),
                                        ),
                                        PopupMenuItem(
                                          value: 'transfer',
                                          child: Text("Bank Transfer"),
                                        ),
                                        PopupMenuItem(
                                          value: 'card',
                                          child: Text("Card"),
                                        )
                                      ];
                                    }),
                              ],
                              title: 'Sales Data',
                              range: dateRangeHolder(context, isBigScreen),
                              allowMultipleSelection: allowMultipleSelection,
                              returnSelection: handleSelection,
                              longPress: false,
                            ),
                          ),
                          isBigScreen
                              ? AnimatedContainer(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  duration: Duration(milliseconds: 600),
                                  width: selectedItem.isNotEmpty
                                      ? isBigScreen
                                          ? 650.0
                                          : double.infinity
                                      : 0.00,
                                  child: selectedItem.isNotEmpty
                                      ? ShowDetails(
                                          dataList: selectedItem,
                                          handleUpdate: handleUpdate,
                                          updatePageInfo: updatePageInfo)
                                      : Container(),
                                )
                              : SizedBox.shrink()
                        ]),
                ],
              ),
            ),
          ));
    });
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
                      getSales();
                    });
                  },
                  child: Text('Reset'),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _fromDate = DateTime.now();
                      _toDate = DateTime.now();
                      getSales();
                    });
                  },
                  icon: Icon(Icons.cancel_outlined)),
        ],
      ),
    );
  }

  handleCalculations() {
    double totalSales = 0;
    double transfer = 0;
    double card = 0;
    double cash = 0;
    double discount = 0;
    double profit = 0;

    for (var i = 0; i < filteredsales.length; i++) {
      totalSales += filteredsales[i]['totalAmount'];
      discount += filteredsales[i]['discount'];
      transfer += filteredsales[i]['transfer'];
      card += filteredsales[i]['card'];
      cash += filteredsales[i]['cash'];
      profit += filteredsales[i]['profit'];
    }

    return {
      'total_sales': totalSales,
      'total_paid': totalSales - discount,
      'no_of_sale': filteredsales.length,
      'transfer': transfer,
      'card': card,
      'cash': cash,
      'discount': discount,
      'profit': profit
    };
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
          title: 'No of Sales',
          icon: Icons.payments_outlined,
          currency: false,
          value: data['no_of_sale'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Sales Value',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['total_sales'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Total Paid',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['total_paid'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Transfers',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['transfer'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Card Payments',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['card'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Cash Payments',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['cash'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Discounts',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['discount'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
        InfoCard(
          title: 'Porfit',
          icon: Icons.payments_outlined,
          currency: true,
          value: data['profit'].toString(),
          fontSize: isBigScreen ? 20 : 10,
          color: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
}
