import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invease/app_router.gr.dart';

import '../helpers/providers/theme_notifier.dart';
import '../helpers/providers/token_provider.dart';

List<Widget> actions(BuildContext context, ThemeNotifier themeNotifier,
    TokenNotifier tokenNotifier) {
  return [
    IconButton(
      icon: const Icon(Icons.remove_red_eye),
      onPressed: () {
        if (themeNotifier.themeMode == ThemeMode.light) {
          themeNotifier.setTheme(ThemeMode.dark);
        } else {
          themeNotifier.setTheme(ThemeMode.light);
        }
      },
    ),
    IconButton(
      icon: const Icon(Icons.logout_outlined),
      onPressed: () {
        context.router.replaceAll([LoginRoute()]);
        print('logeed out');
        tokenNotifier.logout();
      },
    ),
  ];
}
