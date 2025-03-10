import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenNotifier with ChangeNotifier, WidgetsBindingObserver {
  String? _token;

  SharedPreferences? preferences;
  TokenNotifier() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      clearToken();
    }
  }

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Map? get decodedToken => _token != null ? JwtDecoder.decode(_token!) : {};
  String? get token => _token;

  void setToken(String token, BuildContext context) {
    _token = token;
    preferences?.setString("access_token", token);
    notifyListeners();
  }

  void logout() {
    _token = null;
    clearToken();
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    preferences!.remove("access_token");
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("access_token");

    if (storedToken != null) {
      _token = storedToken;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void _setToken(Map? token) {
  //   _decodedToken = token;
  //   notifyListeners();
  // }

  // Map? _getUserObject() {
  //   String? token = preferences?.getString('access_token');
  //   return JwtDecoder.decode(token!);
  // }

  // void setRawToken(String? token) {
  //   _rawToken = token;
  //   checkToken();
  // }

  // void getTokenfromStorageAndDecode() async {
  //   String? token = preferences?.getString('access_token');
  //   setRawToken(token);
  // }

  // void clearToken() {
  //   _decodedToken = null;
  //   _rawToken = null;
  //   notifyListeners();
  // }

  // void checkToken() {
  //   if (_rawToken != null) {
  //     if (JwtDecoder.isExpired(_rawToken!)) {
  //       clearToken();
  //     } else {
  //       _setToken(JwtDecoder.decode(_rawToken!));
  //     }
  //   }
  // }
}
