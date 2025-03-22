import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';
import 'theme.dart';
// import 'helpers/providers/token_provider.dart';
// import 'screens/menu.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final router = appRouter;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      tokenNotifier.initializePreferences();
      themeNotifier.initializePreferences();
      themeNotifier.getTheme();

      return MaterialApp.router(
        routerConfig: router.config(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeNotifier.themeMode,
      );
    });
  }
}

/**
 * 
 */
