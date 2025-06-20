import 'package:flutter/material.dart';
import 'package:shelf_sense/services/api.service.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

class MyWindowListener extends WindowListener {
  final ApiService _apiService = ApiService();
  @override
  void onWindowClose() async {
    await _apiService.getRequest('/do-backup');
    toastification.show(
      title: Text("Shutting Down Please Wait..."),
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
    await windowManager.destroy();
  }
}
