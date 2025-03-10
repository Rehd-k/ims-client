import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';
import 'theme.dart';
// import 'helpers/providers/token_provider.dart';
// import 'screens/menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      tokenNotifier.initializePreferences();
      themeNotifier.initializePreferences();
      themeNotifier.getTheme();

      final appRouter = AppRouter(decodedToken: tokenNotifier.decodedToken);
      return MaterialApp.router(
        routerConfig: appRouter.config(),
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
