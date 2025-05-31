import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shelf_sense/services/token.service.dart';

import '../../components/tables/gen_big_table/big_table_source.dart';
import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../services/api.service.dart';
import 'add_products.dart';
import 'table_column.dart';
import 'view_products.dart';

@RoutePage()
class ProductsIndex extends StatefulWidget {
  const ProductsIndex({super.key});

  @override
  ProductsIndexState createState() => ProductsIndexState();
}

class ProductsIndexState extends State<ProductsIndex> {
  final apiService = ApiService();
  final StringBuffer buffer = StringBuffer();
  final TextEditingController _searchController = TextEditingController();
  final categoryController = TextEditingController();
  late List<ColumnDefinition> _columnDefinitions;
  final JsonEncoder jsonEncoder = JsonEncoder();
  bool isLoading = true;
  List categories = [];
  String selectedCategory = "";
  String searchFeild = 'title';
  String initialSort = 'title';
  List<TableDataModel> selectedRows = [];
  String _searchQuery = '';
  String? barcodeHolder;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  void getCategories() async {
    var dbCategories = await apiService.getRequest('category');
    setState(() {
      categories = dbCategories.data;
      isLoading = false;
    });
  }

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

  setSelectedField(String field) {
    setState(() {
      searchFeild = field;
    });
  }

  setSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  handleSelectedRows(List<TableDataModel> selected) {
    setState(() {
      selectedRows = selected;
    });
  }

  handleShowModal(barcode) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 1,
        padding: const EdgeInsets.all(8.0),
        child: AddProducts(barcode: barcode),
      ),
    );
  }

  @override
  void initState() {
    getCategories();
    _columnDefinitions = columnDefinitionMaps
        .map((map) => ColumnDefinition.fromMap(map))
        .toList();
    super.initState();
  }

  checkProductExistence(barcode) async {
    var dbproducts = await apiService
        .getRequest('products?filter={"barcode" : {"\$regex" : "$barcode"}}');

    var {'products': products, 'totalDocuments': _} = dbproducts.data;

    if (products.length < 1) {
      barcodeHolder = barcode;
      handleShowModal(barcode);
    } else {
      setState(() {
        searchFeild = 'barcode';
        _searchQuery = barcode;
      });
    }
  }

  @override
  void dispose() {
    categoryController.dispose();
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return Scaffold(
          floatingActionButton: smallScreen
              ? FloatingActionButton(
                  onPressed: () {
                    handleShowModal(barcodeHolder);
                  },
                  child: Icon(Icons.add_outlined))
              : null,
          appBar: AppBar(
            actions: [
              !smallScreen
                  ? Expanded(
                      child: Row(children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: searchFeild,
                          hint: Text(
                            'Search Field',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          items: dropDownMaps
                              .map((field) => DropdownMenuItem<String>(
                                    value: field['field'],
                                    child: Text(field['name'],
                                        style: TextStyle(color: Colors.blue)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              searchFeild = value ?? "";
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _submitSearch(),
                          onChanged: (_) => _onSearchChanged(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: DropdownButton<String>(
                        value:
                            selectedCategory.isEmpty ? null : selectedCategory,
                        hint: Text(
                          'Select Category',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text(''),
                          ),
                          ...categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category['title'],
                                    child: Text(category['title'],
                                        style: TextStyle(color: Colors.blue)),
                                  ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value ?? "";
                          });
                        },
                      )),
                    ]))
                  : SizedBox.shrink(),
              JwtService().decodedToken!['role'] == 'cashier'
                  ? SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        handleShowModal(barcodeHolder);
                      },
                      icon: Icon(Icons.add_outlined)),
              ...actions(context, themeNotifier)
            ],
          ),
          drawer: smallScreen
              ? Drawer(
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  child: SideBar())
              : null,
          body: KeyboardListener(
              focusNode: FocusNode()..requestFocus(),
              onKeyEvent: (event) async {
                if (event is KeyDownEvent) {
                  // Collect barcode characters
                  buffer.write(event.character ?? '');
                  if (event.logicalKey == LogicalKeyboardKey.enter) {
                    final scannedData = buffer.toString().trim();
                    buffer.clear();
                    await checkProductExistence(scannedData);
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: ViewProducts(
                        searchFeild: searchFeild,
                        searchQuery: _searchQuery,
                        categoryController: categoryController,
                        isLoading: isLoading,
                        apiService: apiService,
                        categories: categories,
                        setSelectField: setSelectedField,
                        submitSearch: _submitSearch,
                        onSearchChanged: _onSearchChanged,
                        setSelectedCategory: setSelectedCategory,
                        columnDefinitions: _columnDefinitions,
                        selectedCategory: selectedCategory,
                        initialSort: initialSort,
                        selectedRows: selectedRows,
                        handleSelectedRows: handleSelectedRows,
                        jsonEncoder: jsonEncoder,
                        searchController: _searchController,
                        rowsPerPage: rowsPerPage,
                      ))
                ],
              )));
    });
  }
}
