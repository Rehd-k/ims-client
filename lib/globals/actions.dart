import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_router.gr.dart';
import '../helpers/providers/theme_notifier.dart';
import '../services/token.service.dart';

List<Widget> actions(BuildContext context, ThemeNotifier themeNotifier) {
  return [
    IconButton(
      icon: const Icon(Icons.light_mode_outlined),
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
        JwtService().logout();
        context.replaceRoute(LoginRoute());
      },
    ),
  ];
}
