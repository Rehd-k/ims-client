import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shelf_sense/services/settings.service.dart';
import 'package:toastification/toastification.dart';

import '../app_router.gr.dart';
import '../globals/sidebar.dart';
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
  final GlobalKey<SideBarState> _sidebarKey = GlobalKey<SideBarState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String token;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late String passwordErrorMessage = '';
  late String usernameErrorMessage = '';
  late String locations = '';
  bool hidePassword = true;
  bool isLoading = false;
  late List branches = [];
  final ApiService apiServices = ApiService();
  bool loggedIn = false;
  bool showForm = false;
  @override
  void initState() {
    super.initState();
    getSettingnsAndBranch();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void getSettingnsAndBranch() async {
    var responce = await apiServices.getRequest('location');
    setState(() {
      branches = responce.data;
      showForm = true;
    });
  }

  showToast(String toastMessage, ToastificationType type) {
    toastification.show(
      title: Text(toastMessage),
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
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

  handleAddLocation(String location) {
    setState(() {
      locations = location;
    });
  }

  Future<void> handleSubmit(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiServices.postRequest('auth/login', {
        'username': _userController.text,
        'password': _passwordController.text,
        'location': locations,
      });

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        token = response.data['access_token'];
        var openBranch = branches.firstWhere(
            (branch) => branch['_id'] == locations,
            orElse: () => null);
        if (!mounted) return;
        SettingsService().setSettings = openBranch;
        JwtService().setToken = token;
        _sidebarKey.currentState?.doMenuReload();
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
          if (result == 'User not found in this location') {
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
        showToast('Connection Error', ToastificationType.error);
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
                      child: !showForm
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : loginForm(
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
                              isLoading,
                              branches,
                              handleAddLocation),
                    ),
                  ),
                  constraints.maxWidth > 600
                      ? Expanded(
                          flex: 7,
                          child: Image(
                            image: AssetImage('assets/images/banner.png'),
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
