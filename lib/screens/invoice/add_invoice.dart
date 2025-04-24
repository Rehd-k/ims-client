import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../helpers/financial_string_formart.dart';
import 'package:toastification/toastification.dart';

import '../../components/inputs/customer_finder.dart';
import '../../components/inputs/product_finder.dart';
import '../../services/api.service.dart';

@RoutePage()
class AddInvoice extends StatefulWidget {
  const AddInvoice({super.key});

  @override
  AddInvoiceState createState() => AddInvoiceState();
}

class AddInvoiceState extends State<AddInvoice> {
  final List<String> taxes = List.generate(10, (index) => 'Tax $index');
  final TextEditingController productController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<TextEditingController> quantityControllers = [];

  String? selectedCustomer;

  DateTime issueDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  String referenceNumber = 'INV-001';
  bool isRecurring = false;
  String? selectedTemplate;
  List<Map> selectedProducts = [];
  String? discountType;
  double discountValue = 0;
  double receivedAmount = 0;
  ApiService apiService = ApiService(); // Assuming you have an ApiService class
  List filteredProducts = [];
  Map? selectedName;

  Future<List<Map>> _fetchProducts(String query) async {
    final response = await apiService.getRequest(
        'products?filter={"isAvailable" : true, "title": {"\$regex": "$query"}}&sort={"title": 1}&limit=20&skip=0&select=" title price quantity "');

    if (response.statusCode == 200) {
      return List<Map>.from(response.data);
    } else {
      throw Exception('Failed to load names');
    }
  }

  Future<List<Map>> _fetchNames(String query) async {
    final response = await apiService.getRequest(
        'customer?filter={"nameOrPhonenumber": "${nameController.text}"}');
    if (response.statusCode == 200) {
      return List<Map>.from(response.data);
    } else {
      throw Exception('Failed to load names');
    }
  }

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= selectedProducts[index]['quantity']) {
        selectedProducts[index]['buying_quantity'] = newQuantity;
        selectedProducts[index]['amount'] = selectedProducts[index]
                ['buying_quantity'] *
            selectedProducts[index]['price'];
        quantityControllers[index].text = newQuantity.toString();
      }

      if (newQuantity == 0) {
        selectedProducts.removeAt(index);
        quantityControllers.removeAt(index);
      }
    });
  }

  void handleSave() async {
    toastification.show(
      title: Text('Loading...'),
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 3),
    );

    Map<String, dynamic> info = {
      'customer': selectedName,
      'issuedDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'invoiceNumber': referenceNumber,
      'recurring': isRecurring,
      'items': selectedProducts,
      'discount': discountValue,
      'totalAmount': _calculateDueAmount(),
      'tax': 0, //add selected tax values later,
      'previouslyPaidAmount': receivedAmount,
      'note': 'note'
    };
    var response = await apiService.postRequest('invoice', info);
    if (response.statusCode! >= 200 && response.statusCode! <= 300) {
      toastification.show(
        title: Text('Invoice Created Successfully'),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    quantityControllers = List.generate(
      selectedProducts.length,
      (index) => TextEditingController(
        text: selectedProducts[index]['buying_quantity'].toString(),
      ),
    );

    // Initialize random reference number
    referenceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().padLeft(10, '0').substring(0, 10)}';
  }

  @override
  void dispose() {
    productController.dispose();
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  selectUserFromSugestion(suggestion) {
    setState(() {
      selectedName = suggestion;
      nameController.clear();
    });
  }

  deselectUserFromSugestion() {
    setState(() {
      selectedName = null;
    });
  }

  onchange() {
    setState(() {});
  }

  selectProduct(suggestion) {
    setState(() {
      final existingIndex = selectedProducts
          .indexWhere((product) => product['_id'] == suggestion['_id']);
      if (existingIndex != -1) {
        selectedProducts.removeAt(existingIndex);
        quantityControllers.removeAt(existingIndex);
      } else {
        suggestion['buying_quantity'] = 1;
        suggestion['amount'] =
            suggestion['buying_quantity'] * suggestion['price'];
        selectedProducts.add(suggestion);
        quantityControllers.add(
          TextEditingController(text: suggestion['buying_quantity'].toString()),
        );
      }
      // selectedProducts.add(suggestion);
      productController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Invoice')),
      body: SingleChildScrollView(
        child: Padding(
          padding: isSmallScreen
              ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0)
              : const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Create Invoice',
                      style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                ],
              ),
              // First Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Form
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 600;
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              // Customer Dropdown
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 3
                                    : constraints.maxWidth,
                                child: buildNameInput(
                                    selectedName,
                                    nameController,
                                    _fetchNames,
                                    selectUserFromSugestion,
                                    deselectUserFromSugestion,
                                    onchange),
                              ),
                              // Issue Date
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 3.5
                                    : constraints.maxWidth,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Issue Date'),
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      setState(() => issueDate = date);
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: issueDate.toString().split(' ')[0],
                                  ),
                                ),
                              ),
                              // Due Date
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 3.5
                                    : constraints.maxWidth,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Due Date'),
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      setState(() => dueDate = date);
                                    }
                                  },
                                  controller: TextEditingController(
                                      text: dueDate.toString().split(' ')[0]),
                                ),
                              ),
                              // Reference Number
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 3
                                    : constraints.maxWidth,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Reference Number'),
                                  readOnly: true,
                                  initialValue: referenceNumber,
                                ),
                              ),
                              // Recurring
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 3
                                    : constraints.maxWidth,
                                child: Row(
                                  children: [
                                    const Text('Recurring:'),
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: const Text('Yes'),
                                        value: true,
                                        groupValue: isRecurring,
                                        onChanged: (value) => setState(
                                            () => isRecurring = value!),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: const Text('No'),
                                        value: false,
                                        groupValue: isRecurring,
                                        onChanged: (value) => setState(
                                            () => isRecurring = value!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Invoice Template
                              SizedBox(
                                width: isWide
                                    ? constraints.maxWidth / 4
                                    : constraints.maxWidth,
                                child: SizedBox(),
                              ),
                              // Products Dropdown
                              SizedBox(
                                  width: constraints.maxWidth,
                                  child: buildProductInput(productController,
                                      onchange, _fetchProducts, selectProduct)),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: !isSmallScreen ? 140 : 90,
                          dataRowMinHeight: 48,
                          columns: const [
                            DataColumn(label: Text('Product')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Unit Price')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: selectedProducts.asMap().entries.map((entry) {
                            final index = entry.key;
                            final product = entry.value;
                            return DataRow(cells: [
                              DataCell(Text(product['title'])),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      updateQuantity(index,
                                          product['buying_quantity'] - 1);
                                    },
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      validator: (value) {
                                        final intValue =
                                            int.tryParse(value ?? '');
                                        if (intValue == null) {
                                          return 'Enter a valid number';
                                        } else if (intValue < 1) {
                                          return 'Minimum value is 1';
                                        } else if (intValue >
                                            selectedProducts[index]
                                                ['quantity']) {
                                          return 'Maximum value is ${selectedProducts[index]['quantity']}';
                                        }
                                        return null;
                                      },
                                      controller: quantityControllers[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        final newQty = int.tryParse(val);
                                        if (newQty != null && newQty >= 0) {
                                          updateQuantity(index, newQty);
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      updateQuantity(index,
                                          product['buying_quantity'] + 1);
                                    },
                                  ),
                                ],
                              )),
                              DataCell(Text(product['price']
                                  .toString()
                                  .formatToFinancial(isMoneySymbol: true))),
                              DataCell(Text(product['amount']
                                  .toString()
                                  .formatToFinancial(isMoneySymbol: true))),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(
                                      () => selectedProducts.remove(product));
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              !isSmallScreen
                  ? Row(
                      children: [
                        // Second Card
                        Expanded(
                          child: discountNote(isSmallScreen),
                        ),

                        const SizedBox(width: 16),
                        // Third Card
                        Expanded(
                          child: totals(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // Second Card
                        discountNote(isSmallScreen),
                        const SizedBox(height: 16),
                        // Third Card
                        totals(),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Card totals() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Subtotal, Discount, Total

            Row(children: [
              const Text('Subtotal:'),
              const Spacer(),
              Text(_calculateSubtotal()
                  .toString()
                  .formatToFinancial(isMoneySymbol: true)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Discount:'),
              const Spacer(),
              Text(_calculateDiscount()
                  .toString()
                  .formatToFinancial(isMoneySymbol: true)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Total:'),
              const Spacer(),
              Text(_calculateTotal()
                  .toString()
                  .formatToFinancial(isMoneySymbol: true)),
            ]),
            const SizedBox(height: 10),
            const SizedBox(height: 16),
            // Tax

            Row(children: [
              const Text('Tax: '),
              const Spacer(),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tax'),
                  items: taxes.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {},
                ),
              )
            ]),

            const SizedBox(height: 10),
            // Grand Total
            Row(children: [
              const Text('Grand Total: '),
              const Spacer(),
              Text(_calculateGrandTotal()
                  .toString()
                  .formatToFinancial(isMoneySymbol: true)),
            ]),

            const SizedBox(height: 10),
            // Received Amount

            Row(children: [
              const Text('Received Amount: '),
              const Spacer(),
              Expanded(
                  child: TextFormField(
                decoration: const InputDecoration(labelText: 'Received Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() => receivedAmount = parsed);
                  }
                },
              ))
            ]),
            const SizedBox(height: 10),
            // Due Amount
            Divider(),
            Row(
              children: [
                Text(
                  'Due Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                    _calculateDueAmount()
                        .toString()
                        .formatToFinancial(isMoneySymbol: true),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.icon(
                    onPressed: () {},
                    label: Text('Save'),
                    icon: Icon(Icons.send_outlined)),
                OutlinedButton.icon(
                    onPressed: () {
                      handleSave();
                    },
                    label: Text('Save And Send'),
                    icon: Icon(Icons.send_and_archive_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }

  Card discountNote(isSmallScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Discount Section
            !isSmallScreen
                ? Row(
                    spacing: 4,
                    children: [
                      // Discount Type
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Discount Type'),
                          items: const [
                            DropdownMenuItem(
                                value: '', child: Text('Select A Discount')),
                            DropdownMenuItem(
                                value: 'fixed', child: Text('Fixed')),
                            DropdownMenuItem(
                                value: 'percentage', child: Text('Percentage')),
                          ],
                          onChanged: (value) =>
                              setState(() => discountType = value),
                        ),
                      ),

                      // Discount Value
                      Expanded(
                          child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Discount Value'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final parsed = double.tryParse(value);
                          if (parsed != null) {
                            setState(() => discountValue = parsed);
                          }
                        },
                      ))
                    ],
                  )
                : SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        // Discount Type
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Discount Type'),
                          items: const [
                            DropdownMenuItem(
                                value: 'fixed', child: Text('Fixed')),
                            DropdownMenuItem(
                                value: 'percentage', child: Text('Percentage')),
                          ],
                          onChanged: (value) =>
                              setState(() => discountType = value),
                        ),
                        Spacer(),
                        // Discount Value
                        TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(
                              labelText: 'Discount Value'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final parsed = double.tryParse(value);
                            if (parsed != null) {
                              setState(() => discountValue = parsed);
                            }
                          },
                        )
                      ],
                    ),
                  ),

            const SizedBox(height: 10),

            Row(children: [Text('Note')]),
            const SizedBox(height: 5),
            // WYSIWYG Input
            TextFormField(
              decoration: const InputDecoration(labelText: 'Additional Notes'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateSubtotal() {
    return selectedProducts.fold(0, (sum, product) => sum + product['amount']);
  }

  double _calculateDiscount() {
    if (discountType == 'percentage') {
      return _calculateSubtotal() * (discountValue / 100);
    } else if (discountType == 'fixed') {
      return discountValue;
    }
    return 0;
  }

  double _calculateTotal() {
    return _calculateSubtotal() - _calculateDiscount();
  }

  double _calculateGrandTotal() {
    // Add tax logic here if needed
    return _calculateTotal();
  }

  double _calculateDueAmount() {
    return _calculateGrandTotal() - receivedAmount;
  }
}
