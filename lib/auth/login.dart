import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invease/app_router.gr.dart';
import 'package:invease/helpers/providers/token_provider.dart';
import 'package:provider/provider.dart';

import '../services/api.service.dart';
import '../services/token.service.dart';
import 'form.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  final Function()? onResult;
  const LoginScreen({super.key, this.onResult});

  @override
  State<LoginScreen> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String token;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late String passwordErrorMessage = '';
  late String usernameErrorMessage = '';
  bool hidePassword = true;
  bool isLoading = false;
  final ApiService apiServices = ApiService();
  final JwtService jwtService = JwtService();
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void toggleHideShowPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await handleSubmit(context);
    }
  }

  showToast(String? message) => Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      webShowClose: true,
      fontSize: 16.0);

  Future<void> handleSubmit(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiServices.postRequest('auth/login', {
        'username': _userController.text,
        'password': _passwordController.text,
      });
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        token = response.data['access_token'];
        if (!mounted) return;
        final auth = Provider.of<TokenNotifier>(context, listen: false);

        await jwtService.saveToken(token);
        auth.setToken(token, context);

        setState(() {
          loggedIn = true;
        });
      } else {
        if (response.data['statusCode'] == 401) {
          var result = response.data['message'];
          if (result == 'Invalid password') {
            setState(() {
              passwordErrorMessage = result;
              isLoading = false;
            });

            passwordFocus.requestFocus();
          }
          if (result == 'User not found') {
            setState(() {
              usernameErrorMessage = result;
              isLoading = false;
            });

            usernameFocus.requestFocus();
          }
        } else {}
      }
    } on DioException catch (e, _) {
      if (e.type == DioExceptionType.connectionError) {
        showToast('Connection Error');
        setState(() {
          isLoading = false;
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  emptyErrorMessage() {
    setState(() {
      passwordErrorMessage = '';
      usernameErrorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == true) {
      context.router.replaceAll([DashboardRoute()]);
    }
    return Scaffold(
      body: Container(
          color: Theme.of(context).cardColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Expanded(
                    flex: constraints.maxWidth > 600 ? 4 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loginForm(
                          context,
                          _formKey,
                          _userController,
                          _passwordController,
                          _submit,
                          passwordErrorMessage,
                          usernameErrorMessage,
                          usernameFocus,
                          passwordFocus,
                          emptyErrorMessage,
                          hidePassword,
                          toggleHideShowPassword,
                          isLoading),
                    ),
                  ),
                  constraints.maxWidth > 600
                      ? Expanded(
                          flex: 7,
                          child: Image(
                            image: AssetImage('images/banner.png'),
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(),
                ],
              );
            },
          )),
    );
  }
}
