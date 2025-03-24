// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'data_sources.dart';

class MainTable extends StatefulWidget {
  final List data;
  final Widget range;
  final List columnDefs;
  final Map sortableColumns;
  final List<Widget>? actions;
  final String title;
  final bool isLoading;
  final bool showCheckboxColumn;
  final bool allowMultipleSelection;
  final Function returnSelection;
  final bool longPress;

  const MainTable({
    super.key,
    required this.isLoading,
    required this.data,
    required this.columnDefs,
    required this.sortableColumns,
    required this.actions,
    required this.title,
    required this.range,
    required this.showCheckboxColumn,
    required this.allowMultipleSelection,
    required this.returnSelection,
    required this.longPress,
  });

  @override
  MainTableState createState() => MainTableState();
}

class MainTableState extends State<MainTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  DessertDataSourceAsync? _dessertsDataSource;
  bool isEmpty = false;
  bool hasError = false;
  bool isAutoHeight = false;
  final bool _dataSourceLoading = false;
  final int _initialRow = 0;

  @override
  void initState() {
    super.initState();
    _dessertsDataSource ??= isEmpty
        ? DessertDataSourceAsync.empty(widget.allowMultipleSelection,
            _onRowSelectionChanged, context, widget.longPress)
        : hasError
            ? DessertDataSourceAsync.error(widget.allowMultipleSelection,
                _onRowSelectionChanged, context, widget.longPress)
            : DessertDataSourceAsync(
                data: widget.data,
                columnDefs: widget.columnDefs,
                allowMultipleSelection: widget.allowMultipleSelection,
                handleSelection: _onRowSelectionChanged,
                context: context,
                longPress: widget.longPress,
                actions: widget.actions);
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    final columnName = widget.sortableColumns[columnIndex];
    if (columnName != null) {
      _dessertsDataSource!.sort(columnName, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }
  }

  @override
  void dispose() {
    _dessertsDataSource!.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns {
    return widget.columnDefs.asMap().entries.map((entry) {
      final Map<String, dynamic> column = entry.value;

      return DataColumn(
        label: Text(column['name']),
        onSort: column['sortable']
            ? (columnIndex, ascending) => sort(columnIndex, ascending)
            : null,
      );
    }).toList();
  }

  void _onRowSelectionChanged() {
    final selectedRows = _dessertsDataSource!.getSelectedRows();

    widget.returnSelection(selectedRows);
  }

  @override
  Widget build(BuildContext context) {
    if (_dataSourceLoading) return const SizedBox();

    return SizedBox(
      height: 600, // Or whatever height you want to set
      child: Column(
        children: [
          Expanded(
            child: AsyncPaginatedDataTable2(
              horizontalMargin: 30,
              checkboxHorizontalMargin: 12,
              showCheckboxColumn: widget.showCheckboxColumn,
              columnSpacing: 0,
              wrapInCard: true,
              onPageChanged: (value) {},
              header: Text(
                '${widget.title} ${widget.data.length}',
                style: TextStyle(fontSize: 12),
              ),
              rowsPerPage: _rowsPerPage,
              autoRowsToHeight: isAutoHeight,
              minWidth: 1500,
              fit: FlexFit.tight,
              onRowsPerPageChanged: (value) {
                _rowsPerPage = value!;
              },
              initialFirstRowIndex: _initialRow,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              sortArrowIcon: Icons.keyboard_arrow_up,
              sortArrowAnimationDuration: const Duration(milliseconds: 0),
              onSelectAll: (select) {
                if (select != null && select) {
                  _dessertsDataSource!.selectAll();
                } else {
                  _dessertsDataSource!.deselectAll();
                }
                _onRowSelectionChanged();
              },
              columns: _columns,
              empty: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Text('No data'),
                ),
              ),
              loading: _Loading(),
              errorBuilder: (e) => _ErrorAndRetry(
                e.toString(),
                () => _dessertsDataSource!.refreshDatasource(),
              ),
              source: _dessertsDataSource!,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5), child: widget.range)
        ],
      ),
    );
  }
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
          ),
          padding: const EdgeInsets.all(10),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Oops! $errorMessage',
                  style: const TextStyle(color: Colors.white)),
              TextButton(
                onPressed: retry,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    Text('Retry', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

class _Loading extends StatefulWidget {
  @override
  __LoadingState createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface.withAlpha(128),
      // at first show shade, if loading takes longer than 0,5s show spinner
      child: Center(
        child: Container(
          color: Colors.yellow,
          padding: const EdgeInsets.all(7),
          width: 150,
          height: 50,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
              Text('Loading..')
            ],
          ),
        ),
      ),
    );
  }
}
