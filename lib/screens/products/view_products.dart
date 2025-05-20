import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../components/tables/gen_big_table/big_table.dart';
import '../../components/tables/gen_big_table/big_table_source.dart';
import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';
import 'table_column.dart';

class ViewProducts extends StatefulWidget {
  final TokenNotifier tokenNotifier;
  const ViewProducts({super.key, required this.tokenNotifier});

  @override
  ViewProductsState createState() => ViewProductsState();
}

class ViewProductsState extends State<ViewProducts> {
  final apiService = ApiService();
  final JsonEncoder jsonEncoder = JsonEncoder();
  final TextEditingController _searchController = TextEditingController();
  late List filteredProducts;
  late List products;
  bool isLoading = true;
  String initialSort = 'title';
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String _searchQuery = "";
  String searchFeild = 'title';
  String selectedCategory = "";
  List categories = [];

  List<TableDataModel> _selectedRows = [];

  printSelected() {
    debugPrint(_selectedRows.toString());
  }

  // Convert maps to ColumnDefinition objects
  late List<ColumnDefinition> _columnDefinitions;

  @override
  void initState() {
    super.initState();
    getCategories();
    _columnDefinitions = columnDefinitionMaps
        .map((map) => ColumnDefinition.fromMap(map))
        .toList();
  }

  // --- Handler for submitting search (e.g., on button press or text field submit) ---
  void _submitSearch() {
    // Trigger rebuild only if the query actually changed
    if (_searchQuery != _searchController.text.trim()) {
      setState(() {
        _searchQuery = _searchController.text.trim();
        // The setState call will trigger didUpdateWidget in the child table
      });
    }
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_searchQuery != _searchController.text) {
          setState(() {
            _searchQuery = _searchController.text;
          });
        }
      });
    }
  }

  doShowToast(String toastMessage, ToastificationType type) {
    toastification.show(
      title: Text(toastMessage),
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    // _selectedRowsNotifier.dispose();
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  void getCategories() async {
    var dbCategories = await apiService.getRequest('category');
    setState(() {
      categories = dbCategories.data;
      isLoading = false;
    });
  }

  Future<Map<String, dynamic>> _fetchServerData({
    required int offset,
    required int limit,
    String? sortField,
    bool? sortAscending,
  }) async {
    var sorting = jsonEncoder
        .convert({"$sortField": (sortAscending ?? true) ? 'asc' : 'desc'});

    var dbproducts = await apiService.getRequest(
        'products?filter={"$searchFeild" : {"\$regex" : "${_searchQuery.toLowerCase()}"}, "category" :  {"\$regex" : "${selectedCategory.toLowerCase()}"}}&skip=$offset&limit=$limit&sort=$sorting');

    var {'products': products, 'totalDocuments': totalDocuments} =
        dbproducts.data;
    // --- Sorting Logic (Mock) ---
    List<TableDataModel> data = List.from(products); // Work on a copy

    // --- Pagination Logic (Mock) ---
    final totalRows = totalDocuments;
    final paginatedData = data.toList();

    return {
      'rows': paginatedData, // Return the list of maps
      'totalRows': totalRows,
    };
  }
  // --- End Mock Backend ---

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // --- Add Filter UI Elements ---
      LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          return Flex(
            direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Flexible(
                flex: isSmallScreen ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: searchFeild,
                      hint: const Text('Search Field'),
                      items: dropDownMaps
                          .map((field) => DropdownMenuItem<String>(
                                value: field['field'],
                                child: Text(field['name']),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          searchFeild = value ?? "";
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submitSearch(),
                      onChanged: (_) => _onSearchChanged(),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: isSmallScreen ? 0 : 1,
                child: Center(
                  child: DropdownButton<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    hint: const Text('Select Category'),
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text(''),
                      ),
                      ...categories.map((category) => DropdownMenuItem<String>(
                            value: category['title'],
                            child: Text(category['title']),
                          ))
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? "";
                      });
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      Expanded(
        child: isLoading
            ? Center(
                child: SizedBox(
                    width: 40, height: 40, child: CircularProgressIndicator()),
              )
            : ReusableAsyncPaginatedDataTable(
                columnDefinitions: _columnDefinitions, // Pass definitions
                fetchDataCallback: _fetchServerData,
                onSelectionChanged: (selected) {
                  _selectedRows = selected;
                },
                header: const Text('Products'),
                initialSortField: initialSort,
                initialSortAscending: true,
                rowsPerPage: 15,
                availableRowsPerPage: const [10, 15, 25, 50],
                showCheckboxColumn: true,
                fixedLeftColumns: 1,
                minWidth: 2500,
                empty: const Center(child: CircularProgressIndicator()),
                border: TableBorder.all(color: Colors.grey.shade200, width: 1),
                columnSpacing: 30,
                dataRowHeight: 50,
                headingRowHeight: 60,
              ),
      )
    ]);
  }
}
