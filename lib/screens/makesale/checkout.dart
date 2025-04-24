import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../helpers/financial_string_formart.dart';

import '../../services/api.service.dart';
import '../customers/add_customer.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  final double total;
  final List cart;
  final Function handleComplete;

  const CheckoutScreen(
      {super.key,
      required this.total,
      required this.cart,
      required this.handleComplete});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ApiService apiService = ApiService();
  String selectedPaymentMethod = 'cash';
  String? accountNumber;
  final TextEditingController cashController = TextEditingController();
  final TextEditingController transferController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Map? selectedName;
  double amountPaid = 0;
  double balance = 0;
  double discount = 0;
  bool isBankLoading = true;

  // Mock bank data - replace with your backend data
  List<dynamic> banks = [];

  @override
  void dispose() {
    cashController.dispose();
    transferController.dispose();
    cardController.dispose();
    discountController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future updateBankList() async {
    setState(() {
      isBankLoading = true;
    });
    var dbbanks = await apiService.getRequest(
      'banks?skip=${banks.length}',
    );
    setState(() {
      banks = dbbanks.data;
      isBankLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updateBankList();
    _updateAmountPaid();
  }

  void _updateAmountPaid() {
    setState(() {
      discount = double.tryParse(discountController.text) ?? 0;
      amountPaid = (double.tryParse(cashController.text) ?? 0) +
          (double.tryParse(transferController.text) ?? 0) +
          (double.tryParse(cardController.text) ?? 0.0) +
          discount;
      balance = widget.total - amountPaid;
    });
  }

  void handleSubit() async {
    // Validate total amount matches
    if (amountPaid < widget.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Amount paid must equal or exceed total amount'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Validate bank is selected for transfer payment
    if ((selectedPaymentMethod == 'transfer' ||
            selectedPaymentMethod == 'mixed') &&
        double.tryParse(transferController.text) != null &&
        double.parse(transferController.text) > 0 &&
        accountNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a bank for transfer payment'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final paymentData = {
      'total': widget.total,
      'discount': discount,
      'paymentMethod': selectedPaymentMethod,
      'cash': double.tryParse(cashController.text) ?? 0,
      'transfer': double.tryParse(transferController.text) ?? 0,
      'card': double.tryParse(cardController.text) ?? 0,
      'accountNumber': accountNumber,
      'products': widget.cart,
      'accountName': banks.firstWhere(
          (res) => res["accountNumber"] == accountNumber,
          orElse: () => {"name": ""})["name"],
      'customer': selectedName?['_id']
    };

    // Capture the context before the async gap
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = context.router;

    await apiService.postRequest('sales', paymentData);

    // Check if widget is still mounted before showing message
    if (!mounted) return;

    // Use captured scaffoldMessenger
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Payment processed successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    widget.handleComplete();

    // Use captured router
    router.back();
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

  void _showAddCustomerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddCustomer(
          updateCustomer: _fetchNames,
        );
      },
    );
  }

  Widget _buildNameInput() {
    return selectedName == null
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          tooltip: 'Add new Customer',
                          onPressed: _showAddCustomerBottomSheet,
                          icon: Icon(Icons.person_add_alt_1_outlined)))
                ],
              ),
              if (nameController.text.isNotEmpty)
                FutureBuilder<List<Map>>(
                  future: _fetchNames(nameController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('No suggestions'),
                      );
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map((suggestion) {
                          return ListTile(
                            title: Text(suggestion['name']),
                            subtitle: Text(suggestion['phone_number']),
                            trailing: Text(suggestion['total_spent']
                                .toString()
                                .formatToFinancial(isMoneySymbol: true)),
                            onTap: () {
                              setState(() {
                                selectedName = suggestion;
                                nameController.clear();
                              });
                            },
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
            ],
          )
        : Chip(
            label: Text(selectedName?['name']),
            deleteIcon: Icon(Icons.close),
            onDeleted: () {
              setState(() {
                selectedName = null;
              });
            },
          );
  }

  Widget _buildPaymentInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: (label == 'Transfer' || label == 'Card') &&
                      accountNumber == null
                  ? 'Select bank first'
                  : '',
              child: TextField(
                controller: controller,
                enabled: !((label == 'Transfer' || label == 'Card') &&
                    accountNumber == null),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  _updateAmountPaid();
                },
                decoration: InputDecoration(
                  labelText: '$label Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefix: Text('₦ '),
                ),
              ),
            ),
          ),
          if (label == 'Transfer' || label == 'Card') ...[
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: accountNumber,
                decoration: InputDecoration(
                  labelText: 'Select Bank',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: [
                  ...banks.map((bank) => DropdownMenuItem(
                        value: bank['accountNumber'],
                        child: Text(bank['name']!),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    accountNumber = value;
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          final padding = isDesktop ? 32.0 : 16.0;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(padding),
                constraints: BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child:
                                  _buildPaymentMethodCard(context, isDesktop)),
                          SizedBox(width: 20),
                          Expanded(child: _buildSummaryCard(context)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildPaymentMethodCard(context, isDesktop),
                          SizedBox(height: 20),
                          _buildSummaryCard(context),
                        ],
                      ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: isDesktop
                          ? constraints.maxWidth / 2
                          : double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: balance == 0
                            ? () {
                                handleSubit();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: balance == 0 ? null : Colors.red,
                          disabledBackgroundColor: Colors.red,
                        ),
                        child: Text('Complete Payment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Total Amount:', widget.total, context),
            SizedBox(height: 10),
            _buildSummaryRow('Amount Paid:', amountPaid, context),
            Divider(),
            SizedBox(height: 10),
            _buildDiscountRow(context),
            SizedBox(height: 10),
            _buildSummaryRow('Balance:', balance, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          amount.toStringAsFixed(2).formatToFinancial(isMoneySymbol: true),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discount:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          width: 150,
          child: TextField(
            controller: discountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (value) => _updateAmountPaid(),
            decoration: InputDecoration(
              prefix: Text('₦ '),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context, bool isDesktop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                DropdownMenuItem(value: 'card', child: Text('Card')),
                DropdownMenuItem(value: 'mixed', child: Text('Mixed Payment')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedPaymentMethod == 'cash' ||
                selectedPaymentMethod == 'mixed')
              Column(
                children: [
                  _buildPaymentInput('Cash', cashController),
                ],
              ),
            if (selectedPaymentMethod == 'transfer' ||
                selectedPaymentMethod == 'mixed')
              Column(
                children: [
                  _buildPaymentInput('Transfer', transferController),
                ],
              ),
            if (selectedPaymentMethod == 'card' ||
                selectedPaymentMethod == 'mixed')
              Column(
                children: [
                  _buildPaymentInput('Card', cardController),
                ],
              ),
            _buildNameInput(),
          ],
        ),
      ),
    );
  }
}
