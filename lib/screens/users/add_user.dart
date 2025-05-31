import 'package:flutter/material.dart';
import '../../services/api.service.dart';

class AddUser extends StatefulWidget {
  final Function()? updateUserList;
  const AddUser({super.key, this.updateUserList});

  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  final apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final username = TextEditingController();

  final firstName = TextEditingController();

  final lastName = TextEditingController();

  final password = TextEditingController();

  final role = TextEditingController();
  late List branches = [];
  late String locations;
  late FocusNode usernameFocus;
  bool showForm = false;

  final userController = TextEditingController();
  late String usernameErrorMessage = '';

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    password.dispose();
    role.dispose();
    userController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocations();
    usernameFocus = FocusNode();
  }

  void getLocations() async {
    var responce = await apiService.getRequest('/location');
    setState(() {
      showForm = true;
      branches = responce.data;
    });
  }

  handleAddLocation(String location) {
    setState(() {
      locations = location;
    });
  }

  void handleSubmit(BuildContext context) async {
    try {
      final dynamic response = await apiService.postRequest('/auth/register', {
        'firstName': firstName.text,
        'lastName': lastName.text,
        'username': username.text,
        'password': password.text,
        'role': role.text,
        'location': locations
      });
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        widget.updateUserList!();
      } else {
        if (response.data['statusCode'] == 500) {
          var result = response.data['message'];
          if (result == 'User with username rhed already exists') {
            setState(() {
              usernameErrorMessage = result;
            });
            usernameFocus.requestFocus();
          }
        }
      }
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
                  controller: firstName,
                  decoration: InputDecoration(
                    labelText: 'First Name *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lastName,
                  decoration: InputDecoration(
                    labelText: 'Last Name *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    errorText: usernameErrorMessage,
                  ),
                ),
                // SizedBox(height: 10),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                DropdownMenu(
                  width: double.infinity,
                  initialSelection: 'No Brand',
                  controller: role,

                  requestFocusOnTap: true,
                  label: const Text('Role'),
                  // onSelected: (ColorLabel? color) {
                  //   setState(() {
                  //     selectedColor = color;
                  //   });
                  // },
                  dropdownMenuEntries: ['admin', 'manager', 'cashier', 'staff']
                      .map<DropdownMenuEntry<String>>((category) {
                    return DropdownMenuEntry(value: category, label: category);
                  }).toList(),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: branches.map<DropdownMenuItem<String>>((branch) {
                    return DropdownMenuItem<String>(
                      value: branch['_id']
                          .toString(), // Assuming 'id' is the key for the value
                      child: Text(branch[
                          'name']), // Assuming 'name' is the key for the display text
                    );
                  }).toList(),
                  onChanged: (value) {
                    handleAddLocation(value!);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    handleSubmit(context);
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Processing Data',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
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
