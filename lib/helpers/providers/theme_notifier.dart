import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  SharedPreferences? preferences;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    getTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      preferences?.setString('theme', 'light');
    } else if (mode == ThemeMode.dark) {
      preferences?.setString('theme', 'dark');
    } else if (mode == ThemeMode.system) {
      preferences?.setString('theme', 'system');
    }
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    if (theme == 'system') {
      _themeMode = ThemeMode.system;
    } else if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    }
  }
}
