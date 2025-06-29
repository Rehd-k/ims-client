import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shelf_sense/helpers/financial_string_formart.dart';
import 'package:toastification/toastification.dart';

import '../../../app_router.gr.dart';
import '../../../services/token.service.dart';

/// Represents the definition of a single column passed from the parent.
class ColumnDefinition {
  final String name; // Display name for the column header
  final bool sortable; // Can the table be sorted by this column?
  final String
      type; // Data type for formatting ('text', 'number', 'money', 'date', etc.)
  final String field; // Key to access the data in the data model map

  const ColumnDefinition({
    required this.name,
    required this.sortable,
    required this.type,
    required this.field,
  });

  // Helper to create from a map (like the JSON provided)
  factory ColumnDefinition.fromMap(Map<String, dynamic> map) {
    return ColumnDefinition(
      name: map['name'] ?? '',
      sortable: map['sortable'] ?? false,
      type: map['type'] ?? 'text',
      field: map['field'] ?? '',
    );
  }
}

/// Represents the data model for a single row, matching the 'field' names.
/// Using a Map for flexibility, but a dedicated class is often better for type safety.
typedef TableDataModel = Map<String, dynamic>;

/// Signature for the function that fetches data for the table.
typedef FetchDataCallback = Future<Map<String, dynamic>> Function({
  required int offset,
  required int limit,
  String? sortField, // Changed from index to field name
  bool? sortAscending,
});

typedef SelectionChangedCallback = void Function(
    List<TableDataModel> selectedRows);

// --- Formatting Helper Functions ---
// Replace these with your actual formatting logic

String formatDate(String isoDate) {
  final DateTime parsedDate = DateTime.parse(isoDate);
  return DateFormat('dd-MM-yyyy').format(parsedDate);
}

String formatNumber(dynamic value) {
  return value?.toString().formatToFinancial(isMoneySymbol: false) ?? '';
}

String formatMoney(dynamic value) {
  return value?.toString().formatToFinancial(isMoneySymbol: true) ?? '';
}

String formatText(dynamic value) {
  return value?.toString() ?? '';
}

num getSold(List sold) {
  return sold.fold(0, (sum, item) => sum + (item["amount"] ?? 0));
}

String formatSold(dynamic value) {
  return getSold(value).toString().formatToFinancial(isMoneySymbol: false);
}

doShowToast(String toastMessage, ToastificationType type) {
  toastification.show(
    title: Text(toastMessage),
    type: type,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

class MyAsyncDataSource extends AsyncDataTableSource {
  final FetchDataCallback fetchDataCallback;
  final SelectionChangedCallback onSelectionChanged;
  final List<ColumnDefinition> columnDefinitions; // Use definitions now
  final Function(dynamic rowData)
      doDamagedGoods; // Example callback for an action button
  final Function? handleShowDetails;
  // final VoidCallback?
  final BuildContext context;

  // Internal state
  List<TableDataModel> _data =
      []; // Holds the currently loaded data page (List of Maps)
  int _totalRows = 0;
  int _currentPageOffset = 0;
  final Set<String> _selectedRowIds =
      {}; // Store IDs ('_id' field from ProductDataModel)

  // Parameters for fetching
  String? _sortField; // Store field name for sorting
  bool? _sortAscending;

  MyAsyncDataSource({
    required this.fetchDataCallback,
    required this.onSelectionChanged,
    required this.columnDefinitions,
    required this.doDamagedGoods,
    required this.context,
    this.handleShowDetails,
    String? initialSortField,
    bool? initialSortAscending,
  }) {
    _sortField = initialSortField;
    _sortAscending = initialSortAscending;
  }

  bool isBigScreen() {
    return MediaQuery.of(context).size.width > 600;
  }

  // Method to trigger a data refresh
  void refreshData({
    String? sortField,
    bool? sortAscending,
  }) {
    _sortField = sortField;
    _sortAscending = sortAscending;
    _data.clear();
    _totalRows = 0;
    _currentPageOffset = 0;

    refreshDatasource(); // Notify listeners
  }

  // Method to update selection state
  void _handleSelectChanged(String rowId, bool? selected, int index) {
    final model = _data.firstWhere((m) => m['_id'] == rowId, orElse: () => {});
    if (model.isEmpty) return; // Should not happen if ID exists

    if (selected == true) {
      setRowSelection(ValueKey<int>(index), true);
      _selectedRowIds.add(rowId);
    } else {
      setRowSelection(ValueKey<int>(index), false);
      _selectedRowIds.remove(rowId);
    }

    // Notify the parent widget
    final selectedData = _data
        .where((m) => _selectedRowIds.contains(m['_id']))
        .toList(); // Already a list of maps
    onSelectionChanged(selectedData);
    notifyListeners();
  }

  // --- Dynamic Cell Generation ---
  DataCell _buildCell(TableDataModel rowData, ColumnDefinition colDef) {
    final dynamic value = rowData[colDef.field];
    Widget formattedValue;

    // Apply formatting based on type
    switch (colDef.type) {
      case 'date':
        formattedValue = Text(formatDate(value));
        break;
      case 'number':
        formattedValue = Text(formatNumber(value));
        break;
      case 'money':
        formattedValue =
            Text(formatMoney(value), style: TextStyle(fontFamily: ''));
        break;
      case 'sold':
        formattedValue = Text(formatSold(value));

      case 'text':
      case 'string': // Treat string same as text
      default:
        formattedValue = SelectableText(formatText(value));
    }

    // Special handling for 'Actions' column (or any column needing widgets)
    if (colDef.field == '') {
      // Assuming empty field means actions
      return DataCell(viewProductDetails(rowData));
    }

    if (colDef.field == 'invoiceActions') {
      return DataCell(IconButton(
        icon: Icon(Icons.login_outlined),
        onPressed: () {
          context.router
              .push(ViewInvoices(invoiceId: rowData['invoiceNumber']));
        },
      ));
    }

    if (colDef.field == 'show_sales_details') {
      return DataCell(IconButton(
          onPressed: () {
            handleShowDetails!(rowData, isBigScreen());
          },
          icon: Icon(
            Icons.view_agenda,
            color: Theme.of(context).colorScheme.primary.withAlpha(180),
          )));
    }

    // Special handling for 'Actions' column (or any column needing widgets)
    if (colDef.field == 'purchases_actions') {
      // Assuming empty field means actions
      return DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline,
                color: Theme.of(context).colorScheme.primary, size: 18),
            tooltip: 'Do Damaged',
            splashRadius: 18,
            onPressed: () {
              doDamagedGoods(rowData);

              // Potentially call a callback passed to the source
              // e.g., onShowDetails?.call(rowData);
            },
          ),
          // rowData['sold'].isEmpty()
          //     ? IconButton(
          //         icon: Icon(Icons.delete_forever_outlined,
          //             color: Theme.of(context).colorScheme.primary, size: 18),
          //         tooltip: 'Delete',
          //         splashRadius: 18,
          //         onPressed: () {

          //         },
          //       )
          //     : SizedBox(),
        ],
      ));
    }

    // Default cell with formatted text
    return DataCell(formattedValue);
  }

  Row viewProductDetails(TableDataModel rowData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.login_outlined,
              color: Theme.of(context).colorScheme.primary, size: 18),
          tooltip: 'View Details',
          splashRadius: 18,
          onPressed: () {
            var userinfo = JwtService().decodedToken;
            if (userinfo?['role'] == 'admin') {
              context.router.push(ProductDashboard(
                  productId: rowData['_id'], productName: rowData['title']));
            } else {
              doShowToast(
                  'You Cannot Access This Section', ToastificationType.info);
            }
          },
        ),
        // Add more action buttons if needed
      ],
    );
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    Color getRowColor(Map<String, dynamic> data) {
      if (data['status'] != null && data['status'] == 'Not Delivered') {
        return Colors.red.withAlpha(77);
      }
      if (data['debt'] != null && data['debt'] > 0) {
        return Colors.yellow.withAlpha(77);
      }

      if (data['status'] != null) {
        return Colors.green.withAlpha(77);
      }

      if (data['isAvailable'] != null && data['isAvailable'] != true) {
        return Colors.red.withAlpha(77);
      }

      if (data['quantity'] != null &&
          data['roq'] != null &&
          data['quantity'] <= data['roq']) {
        return Colors.yellow.withAlpha(77);
      }

      if (data['quantity'] != null && data['quantity'] < 1) {
        return Colors.red.withAlpha(77);
      } else if (data['quantity'] != null && data['quantity'] > 1) {
        return Colors.green.withAlpha(77);
      }
      return Colors.green.withAlpha(00);
    }

    try {
      // Basic caching: Fetch only if data is empty or page changes
      if (_data.isEmpty || startIndex != _currentPageOffset) {
        final result = await fetchDataCallback(
            offset: startIndex,
            limit: count,
            sortField: _sortField, // Pass field name
            sortAscending: _sortAscending);

        // Expecting List<Map<String, dynamic>> directly
        _data = List<TableDataModel>.from(result['rows'] as List);
        _totalRows = result['totalRows'] as int;
        _currentPageOffset = startIndex;

// ikenna remove this later because they all have thier id
        // Ensure unique IDs for selection (add if missing)
        for (var row in _data) {
          row.putIfAbsent('_id', () => UniqueKey().toString());
        }
      } else {}

      // Adjust total rows if backend indicates end of data
      if (_data.length < count &&
          (_currentPageOffset + _data.length) == _totalRows) {
        // No adjustment needed if backend totalRows is accurate
      } else if (_data.length < count) {
        // If backend total is approximate, adjust based on fetch
        _totalRows = startIndex + _data.length;
      }

      final rows = _data.asMap().entries.map((entry) {
        final index = entry.key + startIndex;
        final rowData = entry.value;

        // Ensure the row has an ID for the key and selection
        final String rowId =
            rowData['_id'] as String? ?? UniqueKey().toString();
        if (!rowData.containsKey('_id')) {
          rowData['_id'] = rowId; // Add ID if missing
        }

        return DataRow(
          color: WidgetStateProperty.resolveWith(
            (states) => getRowColor(rowData),
          ),
          key: ValueKey<int>(index),
          selected: _selectedRowIds.contains(rowId),
          onSelectChanged: (selected) =>
              _handleSelectChanged(rowId, selected, index),
          // Generate cells dynamically based on column definitions
          cells: columnDefinitions
              .map((colDef) => _buildCell(rowData, colDef))
              .toList(),
        );
      }).toList();

      return AsyncRowsResponse(_totalRows, rows);
    } catch (_) {
      return AsyncRowsResponse(0, []); // Return empty on error
    }
  }
}
