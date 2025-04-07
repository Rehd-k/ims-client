import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invease/helpers/providers/token_provider.dart';

import '../../services/api.service.dart';

class AddProducts extends StatefulWidget {
  final Function()? updateProducts;
  final TokenNotifier tokenNotifier;
  const AddProducts(
      {super.key, required this.updateProducts, required this.tokenNotifier});

  @override
  AddProductsState createState() => AddProductsState();
}

class AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final categoryController = TextEditingController();

  final priceController = TextEditingController();

  final roqController = TextEditingController();

  final quantityController = TextEditingController();

  final descriptionController = TextEditingController();

  final brandController = TextEditingController();

  final supplierController = TextEditingController();

  final weightController = TextEditingController();

  final unitController = TextEditingController();

  final barcodeController = TextEditingController();

  final imageUrlController = TextEditingController();

  var isAvailableController = false;

  final soldController = TextEditingController();

  final userController = TextEditingController();

  final ApiService apiServices = ApiService();

  int quantity = 0;

  var rng = Random();

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    priceController.dispose();
    roqController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    supplierController.dispose();
    weightController.dispose();
    unitController.dispose();
    barcodeController.dispose();
    imageUrlController.dispose();
    // isAvailableController.dispose();
    soldController.dispose();

    super.dispose();
  }

  handleQuantityChange(String innerQuantity) {
    setState(() {
      quantity = int.tryParse(innerQuantity) ?? 0;
    });
  }

  Future<void> handleSubmit(BuildContext context) async {
    try {
      final dynamic response = await apiServices.postRequest('/products', {
        'title': titleController.text,
        'category': categoryController.text,
        'price': priceController.text,
        'roq': roqController.text,
        'quantity': quantity,
        'description': descriptionController.text,
        'brand': brandController.text,
        'weight': weightController.text,
        'unit': unitController.text,
        'barcode': barcodeController.text,
        'isAvailable': isAvailableController,
        'initiator': userController.value.text
      });

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        widget.updateProducts!();
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Product Name *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  width: double.infinity,
                  initialSelection: 'No Brand',
                  controller: categoryController,

                  requestFocusOnTap: true,
                  label: const Text('Category'),
                  // onSelected: (ColorLabel? color) {
                  //   setState(() {
                  //     selectedColor = color;
                  //   });
                  // },
                  dropdownMenuEntries: [
                    'Electronics',
                    'Clothing',
                    'Home Appliances',
                    'Books',
                    'Toys',
                    'Groceries',
                    'Beauty Products',
                    'Sports Equipment',
                    'Automotive',
                    'Furniture'
                  ].map<DropdownMenuEntry<String>>((category) {
                    return DropdownMenuEntry(value: category, label: category);
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Selling Price *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Price';
                    }
                    if (int.parse(value) < 0) {
                      return 'Price cant be 0 or less';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: roqController,
                  decoration: InputDecoration(
                    labelText: 'Re-Order Quantity *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Re-Order Quantity';
                    }
                    if (int.parse(value) < 1) {
                      return 'Re-Order Quantity cannot be less than 1';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    handleQuantityChange(val);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  // controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value != null && int.parse(value) < 0) {
                      return 'Quantity Cannot be less than 0';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value != null && int.parse(value) < 0) {
                      return 'Weight cannot be less than 0';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  width: double.infinity,
                  initialSelection: '',
                  controller: unitController,

                  requestFocusOnTap: true,
                  label: const Text('Units'),
                  // onSelected: (ColorLabel? color) {
                  //   setState(() {
                  //     selectedColor = color;
                  //   });
                  // },
                  dropdownMenuEntries: [
                    'kg',
                    'g',
                    'lb',
                    'oz',
                    'l',
                    'ml',
                    'unit'
                  ].map<DropdownMenuEntry<String>>((category) {
                    return DropdownMenuEntry(value: category, label: category);
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  // readOnly: true,
                  controller: barcodeController,
                  decoration: InputDecoration(
                    labelText: 'Product Id *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [Text('Is Available ')],
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('False'),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: isAvailableController,
                    onChanged: (bool? value) {
                      setState(() {
                        isAvailableController = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('True'),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: isAvailableController,
                    onChanged: (bool? value) {
                      setState(() {
                        isAvailableController = value!;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    userController.text =
                        widget.tokenNotifier.decodedToken!['username'];
                    handleSubmit(context);
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
