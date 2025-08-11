import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toastification/toastification.dart';

import '../../../services/api.service.dart';
import 'add_category.dart';

class ViewCategory extends StatefulWidget {
  final Function()? updateCategory;
  const ViewCategory({super.key, this.updateCategory});

  @override
  ViewCategoryState createState() => ViewCategoryState();
}

class ViewCategoryState extends State<ViewCategory> {
  final apiService = ApiService();
  List filteredCategories = [];
  late List categories = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String searchQuery = "";
  String sortBy = "title";
  bool ascending = true;

  @override
  void initState() {
    super.initState();
    getProductsList();
    filteredCategories = List.from(categories);
  }

  _showToast(String toastMessage, ToastificationType type) {
    toastification.show(
      title: Text(toastMessage),
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  // Search logic
  void filterProducts(String query) {
    setState(() {
      filteredCategories = categories.where((category) {
        return category.values.any((value) =>
            value.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  Future updateCategoryList() async {
    setState(() {
      isLoading = true;
    });
    var dbcategories = await apiService.getRequest(
      'category?skip=${categories.length}',
    );
    setState(() {
      categories.addAll(dbcategories.data);
      filteredCategories = List.from(categories);
      isLoading = false;
    });
  }

  Future<void> deleteCategory(String id) async {
    setState(() {
      isLoading = true;
    });
    var response = await apiService.deleteRequest('category/$id');
    if (response.statusCode! >= 200 && response.statusCode! <= 300) {
      _showToast('Category deleted successfully', ToastificationType.success);
      widget.updateCategory!();
    } else {
      _showToast('Failed to delete category', ToastificationType.error);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future getProductsList() async {
    var dbcategories = await apiService.getRequest('category');
    setState(() {
      categories = dbcategories.data;
      filteredCategories = List.from(categories);
      isLoading = false;
    });
  }

  List getFilteredAndSortedRows() {
    List filteredCategories = categories.where((product) {
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
      case 'title':
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

  void doCategoryActions(String? id, String? title, String? description) {
    showBarModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategory(
          updateCategory: widget.updateCategory,
          id: id,
          title: title,
          description: description),
    );
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
            fixedCornerColor: Theme.of(context).colorScheme.onSecondary,
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
            actions: [
              FilledButton.icon(
                onPressed: () {
                  doCategoryActions('', '', '');
                },
                label: Text('Add new'),
                icon: Icon(Icons.add_box_outlined),
              )
            ],
            header: smallScreen
                ? SizedBox()
                : Row(
                    children: [searchBox(smallScreen)],
                  ),
            columns: [
              DataColumn2(
                  label: Text("Title"),
                  size: ColumnSize.L,
                  onSort: (index, ascending) {
                    setState(() {
                      sortBy = 'title';
                      this.ascending = ascending;
                    });
                  }),
              // DataColumn2(label: Text("Description"), size: ColumnSize.L),
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
            source: CategoryDataSource(
                doCategoryActions: doCategoryActions,
                categories: getFilteredAndSortedRows(),
                deleteCategory: deleteCategory,
                context: context),
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

class CategoryDataSource extends DataTableSource {
  final List categories;
  final BuildContext context;
  final Function(String id) deleteCategory;
  final Function(String? id, String? title, String? description)?
      doCategoryActions;

  String formatDate(String isoDate) {
    final DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  CategoryDataSource({
    required this.deleteCategory,
    required this.doCategoryActions,
    required this.categories,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) return null;
    final category = categories[index];
    return DataRow(
      cells: [
        DataCell(Text(category['title'])),
        // DataCell(Text(category['description'])),
        // DataCell(Text(category['user'])),
        DataCell(Text(formatDate(category['createdAt']))),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  doCategoryActions!(category['_id'], category['title'],
                      category['description']);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: () {
                  deleteCategory(category['_id']);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
