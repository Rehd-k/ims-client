import 'package:flutter/material.dart';

import '../../../../services/api.service.dart';

class EditProduct extends StatefulWidget {
  final Function updatePageInfo;
  final String? productId;

  const EditProduct({
    super.key,
    required this.updatePageInfo,
    required this.productId,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> product = {};
  bool isLoading = true;
  late TextEditingController _titleController;
  late TextEditingController _cartonAmount;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _roqController;
  late TextEditingController _weightController;
  late TextEditingController _brandController;
  late TextEditingController _cartonPrice;
  late String _productType;
  late bool _isAvailable;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() async {
    var prod =
        await apiService.getRequest('products/findone/${widget.productId}');

    setState(() {
      product = prod.data;
      _titleController = TextEditingController(text: product['title']);
      _descriptionController =
          TextEditingController(text: product['description']);
      _priceController =
          TextEditingController(text: product['price'].toString());
      _cartonAmount = TextEditingController(
          text: product['cartonAmount']?.toString() ?? '0');
      _quantityController =
          TextEditingController(text: product['quantity'].toString());
      _isAvailable = product['isAvailable'];
      _roqController = TextEditingController(text: product['roq'].toString());
      _weightController =
          TextEditingController(text: product['weight'].toString());
      _brandController = TextEditingController(text: product['brand']);
      _cartonPrice = TextEditingController(
          text: product['cartonPrice']?.toString() ?? '0');
      _productType = product['type'];
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _cartonAmount.dispose();
    _roqController.dispose();
    _weightController.dispose();
    _brandController.dispose();
    _cartonPrice.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Update product logic here
      final updatedProduct = {
        ...product,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'isAvailable': _isAvailable,
        'roq': int.parse(_roqController.text),
        'weight': int.parse(_weightController.text),
        'brand': _brandController.text,
        'cartonAmount': int.parse(_cartonAmount.text),
        'cartonPrice': double.tryParse(_cartonPrice.text) ?? 0.0,
        'type': _productType
      };
      await apiService.putRequest(
          'products/update/${widget.productId}', updatedProduct);

      widget.updatePageInfo();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_outlined)),
        title: const Text('Edit Product'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cartonPrice,
                      decoration:
                          const InputDecoration(labelText: 'Carton Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a carton price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _roqController,
                      decoration:
                          const InputDecoration(labelText: 'Re-Order Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration:
                          const InputDecoration(labelText: 'Product Weight'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cartonAmount,
                      decoration:
                          const InputDecoration(labelText: 'Amount In Carton'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(labelText: 'Brand'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _productType,
                      decoration: InputDecoration(
                        labelText: 'Product Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                      ),
                      items: ['unit', 'carton']
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                    type[0].toUpperCase() + type.substring(1)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _productType = value;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a product type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Available'),
                      value: _isAvailable,
                      onChanged: (bool value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
