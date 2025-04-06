import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Form loginForm(
    BuildContext context,
    formKey,
    userController,
    passwordController,
    submit,
    passwordErrorMessage,
    usernameErrorMessage,
    usernameFocus,
    passwordFocus,
    emptyErrorMessage,
    hidePassword,
    toggleHideShowPassword,
    isLoading) {
  return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  height: 200,
                  width: 200,
                  'assets/vectors/logo.svg',
                ),
              ),
              SizedBox(height: 100),
              TextFormField(
                onChanged: (value) {
                  emptyErrorMessage();
                },
                focusNode: usernameFocus,
                controller: userController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                    errorText: usernameErrorMessage,
                    labelText: 'Username *',
                    hintText: 'Enter username',
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Theme.of(context).hintColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    )),
                validator: (value) {
                  switch (value) {
                    case null:
                      return 'Please enter your username';
                    case '':
                      return 'Username cannot be empty';
                    default:
                      return null;
                  }
                },
              ),
              SizedBox(height: 40),
              TextFormField(
                onChanged: (value) {
                  emptyErrorMessage();
                },
                focusNode: passwordFocus,
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      color: Theme.of(context).disabledColor,
                      iconSize: 18,
                      onPressed: () {
                        toggleHideShowPassword();
                      },
                      icon: hidePassword
                          ? Icon(Icons.lock_outline)
                          : Icon(Icons.lock_open),
                    ),
                    errorText: passwordErrorMessage,
                    labelText: 'Password *',
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Theme.of(context).hintColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    )),
                obscureText: hidePassword,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your password';
                  } else if (value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              isLoading
                  ? CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        submit(context);
                        // context.router.pushNamed('/dashboard');
                      },
                      child: Text(
                        'Login',
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ),
            ],
          ),
        ],
      ));
}
