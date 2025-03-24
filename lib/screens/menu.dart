import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../globals/actions.dart';
import '../globals/sidebar.dart';
import '../helpers/providers/theme_notifier.dart';
import '../helpers/providers/token_provider.dart';

@RoutePage()
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          body: Row(
        children: [
          !smallScreen
              ? Expanded(
                  flex: 1,
                  child: Container(
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: SideBar(tokenNotifier: tokenNotifier)))
              : Container(),
          Expanded(flex: 5, child: AutoRouter())
        ],
      ));
    });
  }
}
