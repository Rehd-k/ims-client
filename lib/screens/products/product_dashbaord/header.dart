import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String? selectedField;
  final String? selectedSupplier;
  final String? selectedStatus;
  final Function(String?) onFieldChange;
  final Function(String?) onSupplierChange;
  final Function(String?) onSelectStatus;
  final List suppliers;
  final Container Function(BuildContext, bool) dateRangeHolder;

  const ProductHeader({
    super.key,
    required this.selectedField,
    required this.selectedSupplier,
    required this.selectedStatus,
    required this.onFieldChange,
    required this.onSupplierChange,
    required this.onSelectStatus,
    required this.suppliers,
    required this.dateRangeHolder,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isBigScreen = width >= 1200;
    return Padding(
        padding: EdgeInsets.all(isBigScreen ? 16.0 : 5),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
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
                      value: 'expiryDate',
                      child: Text('Expiry Date'),
                    ),
                    DropdownMenuItem(
                      value: 'purchaseDate',
                      child: Text('Purchase Date'),
                    ),
                    DropdownMenuItem(
                      value: 'deliveryDate',
                      child: Text('Delivery Date'),
                    ),
                  ],
                  onChanged: onFieldChange,
                  value: selectedField,
                ),
                SizedBox(height: 16.0),
                dateRangeHolder(context, isBigScreen),
              ],
            )),
            SizedBox(width: isBigScreen ? 30 : 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Suppliers',
                    border: OutlineInputBorder(),
                  ),
                  items: suppliers.map<DropdownMenuItem<String>>((cashier) {
                    return DropdownMenuItem<String>(
                      value: cashier['_id'].toString(),
                      child: Text(cashier['name'].toString()),
                    );
                  }).toList(),
                  onChanged: onSupplierChange,
                  value: selectedSupplier,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
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
                      value: 'Delivered',
                      child: Text('Delivered'),
                    ),
                    DropdownMenuItem(
                      value: 'Not Delivered',
                      child: Text('Not Delivered'),
                    )
                  ],
                  onChanged: onSelectStatus,
                  value: selectedStatus,
                ),
              ],
            ))
          ],
        ));
  }
}
