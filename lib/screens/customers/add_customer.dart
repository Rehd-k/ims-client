import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';

class AddCustomer extends StatefulWidget {
  final Function()? updateCustomer;
  const AddCustomer({super.key, required this.updateCustomer});

  @override
  AddCustomerState createState() => AddCustomerState();
}

class AddCustomerState extends State<AddCustomer> {
  final apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final contactController = TextEditingController();

  final emailController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final addressController = TextEditingController();

  final initiatorController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    initiatorController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit(BuildContext context) async {
    try {
      final dynamic response = await apiService.postRequest('/customers', {
        'name': nameController.text,
        'email': emailController.text,
        'phone_number': phoneNumberController.text,
        'address': addressController.text,
        'initiator': initiatorController.text
      });

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        widget.updateCustomer!();
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenNotifier>(builder: (context, tokenNotifier, child) {
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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      labelStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                      )),
                  SizedBox(height: 10),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                      )),
                  SizedBox(height: 10),
                  TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                      )),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      initiatorController.text =
                          tokenNotifier.decodedToken?['username'];
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
    });
  }
}
