import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/financial_string_formart.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../services/api.service.dart';
import 'add_bank.dart';

class ViewBanks extends StatefulWidget {
  final Function()? updateBank;
  const ViewBanks({super.key, this.updateBank});

  @override
  ViewBanksState createState() => ViewBanksState();
}

class ViewBanksState extends State<ViewBanks> {
  final apiService = ApiService();
  List filteredBanks = [];
  late List banks = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String searchQuery = "";
  String sortBy = "name";
  bool ascending = true;

  void filterProducts(String query) {
    setState(() {
      filteredBanks = banks.where((bank) {
        return bank.values.any((value) =>
            value.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  Future updateBankList() async {
    setState(() {
      isLoading = true;
    });
    var dbbanks = await apiService.getRequest(
      'bank?skip=${banks.length}',
    );
    setState(() {
      banks.addAll(dbbanks.data);
      filteredBanks = List.from(banks);
      isLoading = false;
    });
  }

  Future getBanksList() async {
    var dbbanks = await apiService.getRequest('banks');
    setState(() {
      banks = dbbanks.data;
      filteredBanks = List.from(banks);
      isLoading = false;
    });
  }

  List getFilteredAndSortedRows() {
    List filteredCategories = banks.where((product) {
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
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getBanksList();
    filteredBanks = List.from(banks);
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
            empty: Text('No Banks Recorded'),
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
                            AddBank(updateBank: widget.updateBank),
                      ),
                      label: Text('Add Bank'),
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
              DataColumn2(label: Text("Account Number"), size: ColumnSize.L),
              DataColumn2(label: Text("Balance")),
              DataColumn2(label: Text("Is Active")),
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
            source: BanksDataSource(banks: getFilteredAndSortedRows()),
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

class BanksDataSource extends DataTableSource {
  final List banks;

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  BanksDataSource({required this.banks});

  @override
  DataRow? getRow(int index) {
    if (index >= banks.length) return null;
    final bank = banks[index];
    return DataRow(
      cells: [
        DataCell(Text(bank['name'])),
        DataCell(Text(bank['accountNumber'])),
        bank['isActive'] ? DataCell(Text('True')) : DataCell(Text('False')),
        DataCell(Text(
            bank['balance'].toString().formatToFinancial(isMoneySymbol: true))),
        DataCell(Text(bank['initiator'])),
        DataCell(Text(formatDate(bank['createdAt']))),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton.outlined(
                tooltip: 'Update', onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton.outlined(
                onPressed: () {},
                icon: Icon(Icons.delete_forever_outlined),
                tooltip: 'Delete'),
          ],
        ))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => banks.length;

  @override
  int get selectedRowCount => 0;
}
