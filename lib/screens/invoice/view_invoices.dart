import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/api.service.dart';
import 'components/filters.dart';
import 'components/infinite_table.dart';

@RoutePage()
class ViewInvoices extends StatefulWidget {
  const ViewInvoices({super.key});

  @override
  ViewInvoicesState createState() => ViewInvoicesState();
}

class ViewInvoicesState extends State<ViewInvoices> {
  ApiService apiService = ApiService();
  String selectedDateField = 'createdAt';
  String selectedForSearch = 'invoiceNumber';
  String searchParams = '';
  String selectedStatus = '';
  List suggestions = [];
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  static const _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  final ExportDelegate exportDelegate =
      ExportDelegate(ttfFonts: {'Poppins': 'assets/fonts/Poppins-Regular.ttf'});

  String currentFrameId = 'invoicePDF';
  List<Invoice> _invoices = [];
  int _currentOffset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  void onFieldChange(value) {
    setState(() {
      selectedDateField = value;
    });
  }

  onInputChange(value) {
    setState(() {
      selectedForSearch = value;
    });
  }

  onSelectStatus(value) {
    setState(() {
      selectedStatus = value;
    });
    _invoices = [];
    _fetchInvoices();
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
    _invoices = [];
    _fetchInvoices();
  }

  handleRangeChanged(String rangeLabel) {
    setState(() {
      selectedDateField = rangeLabel;
    });
  }

  onSearchParamsChange(value) async {
    await Future.delayed(const Duration(seconds: 1));
    _invoices = [];
    setState(() {
      searchParams = value;
    });

    _fetchInvoices();
  }

  Future<void> saveFile(document, String name) async {
    final Directory? dir = await getDownloadsDirectory();
    final File file = File('${dir!.path}/$name.pdf');

    await file.writeAsBytes(await document.save());
    debugPrint('Saved exported PDF at: ${file.path}');
  }

  @override
  void initState() {
    super.initState();

    _fetchInvoices();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchInvoices();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInvoices() async {
    setState(() => _isLoading = true);
    final newItems = await fetchInvoices(_currentOffset, _pageSize);
    setState(() {
      _invoices.addAll(newItems);
      _currentOffset += newItems.length;
      _hasMore = newItems.length == _pageSize;
      _isLoading = false;
    });
  }

  Future<Iterable<Invoice>> fetchInvoices(int offset, int limit) async {
    final response = await apiService.getRequest(
        'invoice?filter={"$selectedForSearch":{"\$regex" : "${searchParams.toLowerCase()}"}, "status" : {"\$regex" : "${selectedStatus.toLowerCase()}"}}&sort={"$selectedDateField":-1}&startDate=$_fromDate&endDate=$_toDate&selectedDateField=$selectedDateField&limit=$_pageSize');

    if (offset >= 60) return [];

    var data = response.data as List;

    return data.map<Invoice>((item) {
      return Invoice(
          invoiceNumber: item['invoiceNumber'],
          customer: item['customer']['name'],
          issueDate: '2025-04-01',
          dueDate: '2025-04-10',
          recurringCycle: 'Monthly',
          total: item['totalAmount'],
          amountPaid: 0,
          status: item['status'],
          items: item['items'],
          discount: item['discount'],
          tax: item['tax']);
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
                icon: Icon(Icons.calendar_today,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withAlpha(180)),
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
                icon: Icon(Icons.calendar_today,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withAlpha(180)),
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

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 2 : 16),
          child: Column(
            children: [
              SizedBox(height: !isSmallScreen ? 40 : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invoice list',
                    style: TextStyle(
                        fontSize: isSmallScreen ? 30 : 54,
                        fontWeight: FontWeight.w100,
                        color: Theme.of(context).primaryColor),
                  ),
                  OutlinedButton.icon(
                      onPressed: () {},
                      label: const Text('Add Invoice'),
                      icon: const Icon(Icons.add)),
                ],
              ),
              const SizedBox(height: 20),
              FilterHeader(
                  selectedDateField: selectedDateField,
                  selectedForSearch: selectedForSearch,
                  selectedStatus: selectedStatus,
                  onFieldChange: onFieldChange,
                  onInputChange: onInputChange,
                  onSelectStatus: onSelectStatus,
                  suggestions: suggestions,
                  dateRangeHolder: dateRangeHolder,
                  onSearchParamsChange: onSearchParamsChange),
              const SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(maxHeight: 500, minHeight: 200),
                child: InvoiceTablePage(
                    invoices: _invoices,
                    scrollController: _scrollController,
                    isLoading: _isLoading,
                    hasMore: _hasMore,
                    exportDelegate: exportDelegate,
                    saveFile: saveFile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
