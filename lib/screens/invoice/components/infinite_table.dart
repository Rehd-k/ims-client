import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';

import 'preview.dart';

class Invoice {
  final String invoiceNumber;
  final String customer;
  final String issueDate;
  final String dueDate;
  final String recurringCycle;
  final num total;
  final num amountPaid;
  final String status;
  final List items;
  final num discount;
  final num tax;

  Invoice(
      {required this.invoiceNumber,
      required this.customer,
      required this.issueDate,
      required this.dueDate,
      required this.recurringCycle,
      required this.total,
      required this.amountPaid,
      required this.status,
      required this.items,
      required this.discount,
      required this.tax});
}

class InvoiceTablePage extends StatelessWidget {
  final List<Invoice> invoices;
  final ScrollController scrollController;
  final bool isLoading;
  final bool hasMore;
  final ExportDelegate exportDelegate;
  final Function(dynamic document, String name) saveFile;

  const InvoiceTablePage(
      {super.key,
      required this.invoices,
      required this.scrollController,
      required this.isLoading,
      required this.hasMore,
      required this.exportDelegate,
      required this.saveFile});

  Color _rowColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green.shade100;
      case 'due':
        return Colors.yellow.shade100;
      case 'overdue':
        return Colors.red.shade100;
      default:
        return Colors.white;
    }
  }

  Widget _headerCell(String title) {
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.blueGrey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          _headerCell('Invoice number'),
          _headerCell('Customer'),
          _headerCell('Issue date'),
          _headerCell('Due date'),
          _headerCell('Recurring cycle'),
          _headerCell('Total'),
          _headerCell('Paid'),
          _headerCell('Status'),
          _headerCell('Action'),
        ],
      ),
    );
  }

  Widget _buildRow(Invoice invoice, BuildContext context) {
    return Container(
        color: _rowColor(invoice.status),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(invoice.invoiceNumber)),
            Expanded(child: Text(invoice.customer)),
            Expanded(child: Text(invoice.issueDate)),
            Expanded(child: Text(invoice.dueDate)),
            Expanded(child: Text(invoice.recurringCycle)),
            Expanded(child: Text('${invoice.total}')),
            Expanded(child: Text('${invoice.amountPaid}')),
            Expanded(child: Text(invoice.status)),
            Expanded(
              child: PopupMenuButton<int>(
                padding: const EdgeInsets.all(1),
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.create_new_folder_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Create Payment",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            ))
                      ],
                    ),
                    onTap: () => {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit_note_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Edit",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            ))
                      ],
                    ),
                    onTap: () => {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.details,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Invoice Details",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            ))
                      ],
                    ),
                    onTap: () => {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ExportFrame(
                              frameId: 'invoicePDF',
                              exportDelegate: exportDelegate,
                              child: InvoicePage(
                                  invoice: invoice,
                                  exportDelegate: exportDelegate,
                                  saveFile: saveFile),
                            );
                          },
                          isScrollControlled: true)
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.upload_file_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Re Send",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            )),
                      ],
                    ),
                    onTap: () => {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.download_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Download Invoce",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            )),
                      ],
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                            size: 16),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Delete",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(180),
                            )),
                      ],
                    ),
                    onTap: () => {},
                  ),
                ],
                // offset: const Offset(0, 100),
                // color: Colors.green,
                elevation: 2,
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: invoices.length + 1,
            itemBuilder: (context, index) {
              if (index < invoices.length) {
                return _buildRow(invoices[index], context);
              } else if (isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!hasMore) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No more invoices')),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
