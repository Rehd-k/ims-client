import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'helpers/providers/theme_notifier.dart';
import 'helpers/providers/token_provider.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => TokenNotifier()..tryAutoLogin())
  ], child: MyApp()));

  // FlutterWindowClose.setWindowShouldCloseHandler(() async {

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   print("Local storage cleared on window close!");

  //   return true;
  // });
}
