import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invease/helpers/financial_string_formart.dart';

import 'make_return.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails(
      {super.key,
      required this.dataList,
      required this.handleUpdate,
      required this.updatePageInfo});

  final List<dynamic> dataList;
  final Function handleUpdate;
  final Function updatePageInfo;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(dataList[0]['products']);

    List<Map<String, dynamic>> returns =
        List<Map<String, dynamic>>.from(dataList[0]['returns']);

    double totalSum = dataList[0]['totalAmount'];
    double totalReturn = returns.fold(0, (sum, item) => sum + item['total']);
    double totalPaid = totalSum - dataList[0]['discount'];
    double discount = dataList[0]['discount'];
    double profit = dataList[0]['profit'];

    return Container(
      height: 600,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: table(context, data, [
                {
                  'name': 'Title',
                  'size': ColumnSize.L,
                  'field': 'title',
                  'type': 'string'
                },
                {
                  'name': 'Quantity',
                  'size': ColumnSize.L,
                  'field': 'quantity',
                  'type': 'number'
                },
                {
                  'name': 'Price',
                  'size': ColumnSize.L,
                  'field': 'price',
                  'type': 'money'
                },
                {
                  'name': 'Total',
                  'size': ColumnSize.L,
                  'field': 'total',
                  'type': 'money'
                },
              ]),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!))),
            height: 200,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  height: 20,
                  child: Center(
                      child: Text('Returns',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12))),
                ),
                SizedBox(
                  height: 170,
                  child: table(context, returns, [
                    {
                      'name': 'Title',
                      'size': ColumnSize.L,
                      'field': 'title',
                      'type': 'string'
                    },
                    {
                      'name': 'Quantity',
                      'size': ColumnSize.L,
                      'field': 'quantity',
                      'type': 'number'
                    },
                    {
                      'name': 'Price',
                      'size': ColumnSize.L,
                      'field': 'price',
                      'type': 'money'
                    },
                    {
                      'name': 'Total',
                      'size': ColumnSize.L,
                      'field': 'total',
                      'type': 'money'
                    },
                    {
                      'name': 'Date',
                      'size': ColumnSize.L,
                      'field': 'returnedAt',
                      'type': 'date'
                    },
                    {
                      'name': 'Handler',
                      'size': ColumnSize.L,
                      'field': 'handler',
                      'type': 'string'
                    },
                  ]),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!))),
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Sale:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  totalSum
                                      .toString()
                                      .formatToFinancial(isMoneySymbol: true),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Paid:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  totalPaid
                                      .toString()
                                      .formatToFinancial(isMoneySymbol: true),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Profit:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  profit
                                      .toString()
                                      .formatToFinancial(isMoneySymbol: true),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  discount
                                      .toString()
                                      .formatToFinancial(isMoneySymbol: true),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Returns:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  totalReturn
                                      .toString()
                                      .formatToFinancial(isMoneySymbol: true),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MakeReturn(
                                                      updatePageInfo:
                                                          updatePageInfo,
                                                      sales: data,
                                                      id: dataList[0]['_id'],
                                                    )));
                                      },
                                      child: Text('Return')),
                                  SizedBox(width: 7),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MakeReturn(
                                                      updatePageInfo:
                                                          updatePageInfo,
                                                      sales: data,
                                                      id: dataList[0]['_id'],
                                                    )));
                                      },
                                      child: Text('Refund')),
                                ],
                              ),
                              SizedBox(height: 4),
                              ElevatedButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.parse(
                                          dataList[0]['createdAt']),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      handleUpdate({
                                        'transactionDate': picked.toString()
                                      });
                                    }
                                  },
                                  child: Text('Back Date')),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataTable2 table(BuildContext context, List<Map<String, dynamic>> data,
      List<Map<String, dynamic>> columns) {
    String formatDate(String isoDate) {
      final DateTime parsedDate = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    }

    return DataTable2(
      dataRowHeight: 35,
      columns: [
        ...columns.map((column) {
          return DataColumn2(label: Text(column['name']), size: column['size']);
        })
      ],
      rows: data.map<DataRow2>((item) {
        return DataRow2(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (data.indexOf(item) % 2 == 1) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.surfaceBright;
                }
                if (data.indexOf(item) % 2 == 1) {
                  return Theme.of(context).colorScheme.surfaceDim;
                } else {
                  return Theme.of(context).colorScheme.surface;
                }
              } else {
                return Theme.of(context).colorScheme.surfaceBright;
              }
            },
          ),
          cells: [
            ...columns.map((columnDef) => DataCell(
                  Text(
                    columnDef['type'] == 'money'
                        ? item[columnDef['field']]
                            .toString()
                            .formatToFinancial(isMoneySymbol: true)
                        : columnDef['type'] == 'number'
                            ? item[columnDef['field']]
                                .toString()
                                .formatToFinancial()
                            : columnDef['type'] == 'date'
                                ? formatDate(
                                    item[columnDef['field']].toString())
                                : item[columnDef['field']].toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                )),
          ],
        );
      }).toList(),
    );
  }
}
