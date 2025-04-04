import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';
import 'services/navigation.service.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('RenderFlex')) {
      debugPrint('RenderFlex Error: ${details.exceptionAsString()}');
      NavigationService.goToErrorPage(
          {'message': details.exceptionAsString()}, null);
    } else {
      FlutterError.presentError(details);
    }
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('RenderFlex')) {
      FlutterError.presentError(details);
    } else {
      FlutterError.presentError(details);
      NavigationService.goToErrorPage(
          {'message': details.exceptionAsString()}, null);
    }
  };

  // Handle Platform and Framework Errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    NavigationService.goToErrorPage({'message': error.toString()}, null);
    return true; // Prevent crash
  };

// Handle Asynchronous Errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize your providers asynchronously before running the app
    final tokenNotifier = TokenNotifier();
    await tokenNotifier.initializePreferences();

    final themeNotifier = ThemeNotifier();
    await themeNotifier.initializePreferences();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => TokenNotifier()..tryAutoLogin())
    ], child: MyApp()));
  }, (error, stack) {
    debugPrint('Async Error: $error');
    NavigationService.goToErrorPage({'message': error.toString()}, null);
  });
}
