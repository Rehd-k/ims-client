import 'package:flutter/material.dart';
import 'package:invease/app_router.gr.dart';

import '../app_router.dart';

class NavigationService {
  static final AppRouter _router = AppRouter(); // Static instance of AppRouter

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static AppRouter get router => _router;

  // Navigate to the dashboard route
  static Future<void> navigateToDashboard() async {
    // await _router.push(DashboardRoute());
  }

  static Future<void> goToErrorPage(Map? details, VoidCallback? fun) async {
    await _router.push(ErrorRoute(details: details, onRetry: fun));
  }

  // Navigate to the make sale page
  static Future<void> navigateToMakeSale() async {
    // await _router.push(MakeSaleRoute());
  }

  // Navigate back
  static void goBack() {
    _router.pop();
  }
}
