import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../globals/actions.dart';
import '../../../globals/sidebar.dart';
import '../../../helpers/providers/theme_notifier.dart';
import '../../../helpers/providers/token_provider.dart';
import 'add_user.dart';
import 'view_users.dart';

@RoutePage()
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends State<UserManagementScreen> {
  final GlobalKey<ViewUsersState> _viewUserKey = GlobalKey<ViewUsersState>();

  void updateUsers() {
    _viewUserKey.currentState?.updateUserList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<TokenNotifier, ThemeNotifier>(
        builder: (context, tokenNotifier, themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(actions: [...actions(themeNotifier, tokenNotifier)]),
        drawer: smallScreen
            ? Drawer(
                backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                child: SideBar(tokenNotifier: tokenNotifier))
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallScreen
                ? SizedBox.shrink()
                : Expanded(
                    flex: 1, child: AddUser(updateUserList: updateUsers)),
            SizedBox(width: smallScreen ? 0 : 20),
            Expanded(
                flex: 2,
                child:
                    ViewUsers(key: _viewUserKey, updateUserList: updateUsers))
          ],
        ),
      );
    });
  }
}
