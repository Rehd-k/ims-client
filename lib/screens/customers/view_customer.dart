import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helpers/constants.dart';
import '../../services/api.service.dart';
import 'add_customer.dart';

class ViewCustomers extends StatefulWidget {
  final Function()? updateCustomer;
  const ViewCustomers({super.key, this.updateCustomer});

  @override
  ViewCustomersState createState() => ViewCustomersState();
}

class ViewCustomersState extends State<ViewCustomers> {
  final apiService = ApiService();
  List filteredCustomers = [];
  late List customers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String searchQuery = "";
  String sortBy = "name";
  bool ascending = true;

  void filterProducts(String query) {
    setState(() {
      filteredCustomers = customers.where((supplier) {
        return supplier.values.any((value) =>
            value.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  Future updateCustomerList() async {
    setState(() {
      isLoading = true;
    });
    var dbcustomers = await apiService.getRequest(
      '${baseUrl}supplier?skip=${customers.length}',
    );
    setState(() {
      customers.addAll(dbcustomers.data);
      filteredCustomers = List.from(customers);
      isLoading = false;
    });
  }

  Future getCustomersList() async {
    var dbcustomers = await apiService.getRequest('${baseUrl}supplier');
    setState(() {
      customers = dbcustomers.data;
      filteredCustomers = List.from(customers);
      isLoading = false;
    });
  }

  List getFilteredAndSortedRows() {
    List filteredCategories = customers.where((product) {
      return product.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    filteredCategories.sort((a, b) {
      if (ascending) {
        return a[sortBy].toString().compareTo(b[sortBy].toString());
      } else {
        return b[sortBy].toString().compareTo(a[sortBy].toString());
      }
    });

    return filteredCategories;
  }

  int getColumnIndex(String columnName) {
    switch (columnName) {
      case 'name':
        return 0;
      case 'createdAt':
        return 1;
      case 'price':
        return 2;
      case 'quantity':
        return 3;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomersList();
    filteredCustomers = List.from(customers);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Column(
      children: [
        smallScreen ? searchBox(smallScreen) : Container(),
        Expanded(
          child: PaginatedDataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            sortColumnIndex: getColumnIndex(sortBy),
            sortAscending: ascending,
            rowsPerPage: rowsPerPage,
            onRowsPerPageChanged: (value) {
              setState(() {
                rowsPerPage = value ?? rowsPerPage;
              });
            },
            empty: Text('No Customers Recorded'),
            minWidth: 1500,
            actions: [
              FilledButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.exit_to_app,
                  size: 10,
                ),
                label: Text(
                  'Extract',
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10),
                ),
              )
            ],
            header: smallScreen
                ? SizedBox(
                    width: 10,
                    child: FilledButton.icon(
                      onPressed: () => showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            AddCustomer(updateCustomer: widget.updateCustomer),
                      ),
                      label: Text('Add Customer'),
                      icon: Icon(Icons.add_box_outlined),
                    ),
                  )
                : Row(
                    children: [searchBox(smallScreen)],
                  ),
            columns: [
              DataColumn2(
                  label: Text("Name"),
                  size: ColumnSize.L,
                  onSort: (index, ascending) {
                    setState(() {
                      sortBy = 'name';
                      this.ascending = ascending;
                    });
                  }),
              DataColumn2(label: Text("Email"), size: ColumnSize.L),
              DataColumn2(label: Text("Phone Number")),
              DataColumn2(label: Text("Address"), size: ColumnSize.L),
              DataColumn2(label: Text("No. of Orders")),
              DataColumn2(label: Text("initiator")),
              DataColumn2(
                label: Text('Added On'),
                size: ColumnSize.L,
                onSort: (index, ascending) {
                  setState(() {
                    sortBy = 'createdAt';
                    this.ascending = ascending;
                  });
                },
              ),
              DataColumn2(label: Text('Actions'))
            ],
            source: CustomersDataSource(customers: getFilteredAndSortedRows()),
            border: TableBorder(
              horizontalInside: BorderSide.none,
              verticalInside: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox searchBox(bool smallScreen) {
    return SizedBox(
      width: smallScreen ? double.infinity : 250,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search...",
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => filterProducts(_searchController.text),
          ),
        ),
        onChanged: (query) => {filterProducts(query), searchQuery = query},
      ),
    );
  }
}

class CustomersDataSource extends DataTableSource {
  final List customers;

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  CustomersDataSource({required this.customers});

  @override
  DataRow? getRow(int index) {
    if (index >= customers.length) return null;
    final supplier = customers[index];
    return DataRow(
      cells: [
        DataCell(Text(supplier['name'])),
        DataCell(Text(supplier['email'])),
        DataCell(Text(supplier['phone_number'])),
        DataCell(Text(supplier['address'])),
        DataCell(Text(supplier['orders'].length.toString())),
        DataCell(Text(supplier['initiator'])),
        DataCell(Text(formatDate(supplier['createdAt']))),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // OutlinedButton(onPressed: () {}, child: Text('Update'))
            // OutlinedButton(onPressed: () {}, child: Text('Delete'))
          ],
        ))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customers.length;

  @override
  int get selectedRowCount => 0;
}
