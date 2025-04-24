import 'package:flutter/material.dart';

class FilterHeader extends StatelessWidget {
  final String? selectedDateField;
  final String? selectedForSearch;
  final String? selectedStatus;
  final Function(String?) onFieldChange;
  final Function(String?) onInputChange;
  final Function(String?) onSelectStatus;
  final Function(String?) onSearchParamsChange;
  final List suggestions;
  final Container Function(BuildContext context, bool isBigScreen)
      dateRangeHolder;

  const FilterHeader(
      {super.key,
      required this.selectedDateField,
      required this.selectedForSearch,
      required this.selectedStatus,
      required this.onFieldChange,
      required this.onInputChange,
      required this.onSelectStatus,
      required this.suggestions,
      required this.dateRangeHolder,
      required this.onSearchParamsChange});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;
    return Padding(
        padding: EdgeInsets.all(isBigScreen ? 16.0 : 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Range Field',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'createdAt',
                      child: Text('Date Created'),
                    ),
                    DropdownMenuItem(
                      value: 'dueDate',
                      child: Text('Due Date'),
                    ),
                    DropdownMenuItem(
                      value: 'issueDate',
                      child: Text('Issue Date'),
                    ),
                  ],
                  onChanged: onFieldChange,
                  value: selectedDateField,
                )),
                SizedBox(width: 16.0),
                Expanded(child: dateRangeHolder(context, isBigScreen))
              ],
            ),
            SizedBox(width: isBigScreen ? 30 : 10, height: 10),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'invoiceNumber',
                      child: Text('Invoice Number'),
                    ),
                    DropdownMenuItem(
                      value: 'customer',
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(
                      value: 'initiator',
                      child: Text('Initiator'),
                    )
                  ],
                  onChanged: onInputChange,
                  value: selectedForSearch,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                  child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search invoices',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: onSearchParamsChange,
              ))
            ]),
            SizedBox(width: isBigScreen ? 30 : 10, height: 10),
            Row(
              children: [
                Expanded(
                    child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text('pending'),
                    ),
                    DropdownMenuItem(
                      value: 'Due',
                      child: Text('Due'),
                    ),
                    DropdownMenuItem(
                      value: 'overDue',
                      child: Text('Over Due'),
                    ),
                    DropdownMenuItem(
                      value: 'paid',
                      child: Text('Paid'),
                    )
                  ],
                  onChanged: onSelectStatus,
                  value: selectedStatus,
                )),
                SizedBox(width: 16.0),
                Expanded(child: SizedBox())
              ],
            ),
          ],
        ));
  }
}
