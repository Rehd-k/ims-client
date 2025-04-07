import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';
import 'services/navigation.service.dart';

void main() async {
// Handle Asynchronous Errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch Flutter framework (widget tree) errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      final errorString = details.exceptionAsString();
      final isNonCritical = _isNonCriticalError(errorString);

      if (isNonCritical) {
        _showToast('Error: $errorString');
      } else {
        NavigationService.goToErrorPage({'message': errorString}, null);
      }
    };

    // Catch platform, async & isolate-level errors
    PlatformDispatcher.instance.onError = (error, stack) {
      final errorString = error.toString();
      final isNonCritical = _isNonCriticalError(errorString);

      if (isNonCritical) {
        _showToast('Error: $errorString');
      } else {
        NavigationService.goToErrorPage({'message': errorString}, null);
      }

      return true; // prevent app crash
    };

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => TokenNotifier()..tryAutoLogin())
    ], child: MyApp()));
  }, (error, stack) {
    final errorString = error.toString();
    final isNonCritical = _isNonCriticalError(errorString);

    if (isNonCritical) {
      _showToast('Error: $errorString');
    } else {
      NavigationService.goToErrorPage({'message': errorString}, null);
    }
  });
}

bool _isNonCriticalError(String error) {
  return error.contains('Image') ||
      error.contains('Unable to load asset') ||
      error.contains('SocketException') ||
      error.contains('TimeoutException') ||
      error.contains('RenderFlex');
}

void _showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
