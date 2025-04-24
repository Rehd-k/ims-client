import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';
import 'services/navigation.service.dart';
import 'theme.dart';
// import 'helpers/providers/token_provider.dart';
// import 'screens/menu.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return ToastificationWrapper(
          child: MaterialApp.router(
        routerConfig: NavigationService.router.config(),
        debugShowCheckedModeBanner: false,
        title: 'Shelf Sense',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeNotifier.themeMode,
      ));
    });
  }
}

/**
 * 
 */
