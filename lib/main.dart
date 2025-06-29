import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_updater/auto_updater.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelf_sense/services/mywindowlistener.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'helpers/providers/theme_notifier.dart';
import 'services/navigation.service.dart';

void main() async {
// Handle Asynchronous Errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      String feedURL = 'https://vessellabs.org/shelfsense/ifite/appcast.xml';

      await autoUpdater.setFeedURL(feedURL);

      windowManager.setPreventClose(true);
      windowManager.addListener(MyWindowListener());
      // Catch Flutter framework (widget tree) errors
    }

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
      final errorString = details.exceptionAsString();
      final isNonCritical = _isNonCriticalError(errorString);
      if (isNonCritical) {
        _showToast('Error: $errorString', ToastificationType.error);
      } else {
        NavigationService.goToErrorPage({'message': errorString}, null);
      }
    };

    // Catch platform, async & isolate-level errors
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      final errorString = error.toString();
      final isNonCritical = _isNonCriticalError(errorString);

      if (isNonCritical) {
        _showToast('Error: $errorString', ToastificationType.error);
      } else {
        NavigationService.goToErrorPage({'message': errorString}, null);
      }

      return true; // prevent app crash
    };

    runApp(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ));
  }, (error, stack) {
    final errorString = error.toString();
    final isNonCritical = _isNonCriticalError(errorString);
    debugPrint(errorString);
    debugPrint(stack.toString());
    if (isNonCritical) {
      _showToast('Error: $errorString', ToastificationType.error);
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

_showToast(String toastMessage, ToastificationType type) {
  toastification.show(
    title: Text(toastMessage),
    type: type,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 2),
  );
}
