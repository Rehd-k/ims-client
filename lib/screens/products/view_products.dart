import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/tables/purchases/purchases_table.dart';
import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';

class ViewProducts extends StatefulWidget {
  final Function()? updateProducts;
  final TokenNotifier tokenNotifier;
  const ViewProducts(
      {super.key, this.updateProducts, required this.tokenNotifier});

  @override
  ViewProductsState createState() => ViewProductsState();
}

class ViewProductsState extends State<ViewProducts> {
  final apiService = ApiService();
  late List filteredProducts;
  late List products;
  bool isLoading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String searchQuery = "";
  String sortBy = "title";
  bool ascending = true;

  @override
  void initState() {
    super.initState();
    getProductsList();
  }

  Future updateProductsList() async {
    setState(() {
      isLoading = true;
    });
    var dbproducts = await apiService.getRequest(
      'products?skip=${products.length}',
    );
    setState(() {
      products.addAll(dbproducts.data);
      filteredProducts = List.from(products);
      isLoading = false;
    });
  }

  Future getProductsList() async {
    isLoading = true;
    var dbproducts = await apiService.getRequest('products?limit=20');
    setState(() {
      products = dbproducts.data;
      filteredProducts = List.from(products);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(child: Consumer<TokenNotifier>(
                  builder: (context, tokenNotifier, child) {
                return MainTable(
                    isLoading: isLoading,
                    data: filteredProducts,
                    columnDefs: [
                      {
                        'name': 'Title',
                        'sortable': true,
                        'type': 'text',
                        'field': 'title'
                      },
                      {
                        'name': 'Category',
                        'sortable': true,
                        'type': 'text',
                        'field': 'category'
                      },
                      {
                        'name': 'Price',
                        'sortable': true,
                        'type': 'money',
                        'field': 'price'
                      },
                      {
                        'name': 'ROQ',
                        'sortable': false,
                        'type': 'number',
                        'field': 'roq'
                      },
                      {
                        'name': 'Quantity',
                        'sortable': true,
                        'type': 'number',
                        'field': 'quantity'
                      },
                      {
                        'name': 'Description',
                        'sortable': false,
                        'type': 'text',
                        'field': 'description'
                      },
                      {
                        'name': 'Brand',
                        'sortable': false,
                        'type': 'text',
                        'field': 'brand'
                      },
                      {
                        'name': 'Weight',
                        'sortable': false,
                        'type': 'number',
                        'field': 'weight'
                      },
                      {
                        'name': 'Unit',
                        'sortable': false,
                        'type': 'string',
                        'field': 'unit'
                      },
                      {
                        'name': 'Available',
                        'sortable': false,
                        'type': 'string',
                        'field': 'isAvailable'
                      },
                      {
                        'name': 'Initiator',
                        'sortable': false,
                        'type': 'string',
                        'field': 'initiator'
                      },
                      {
                        'name': 'Added On',
                        'sortable': false,
                        'type': 'date',
                        'field': 'createdAt'
                      },
                      // {
                      //   'name': 'Actions',
                      //   'sortable': false,
                      //   'type': 'string',
                      //   'field': 'transactionId'
                      // }
                    ],
                    sortableColumns: {},
                    actions: [],
                    title: '',
                    range: SizedBox.shrink(),
                    showCheckboxColumn: false,
                    allowMultipleSelection: false,
                    returnSelection: () {},
                    longPress: tokenNotifier.decodedToken!['role'] == 'cashier'
                        ? false
                        : true);
              }))
            ],
          );
  }
}
