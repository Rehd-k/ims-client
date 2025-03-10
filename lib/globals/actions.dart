import 'package:flutter/material.dart';

import '../helpers/providers/theme_notifier.dart';
import '../helpers/providers/token_provider.dart';

List<Widget> actions(ThemeNotifier themeNotifier, TokenNotifier tokenNotifier) {
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
        tokenNotifier.logout();
      },
    ),
  ];
}
