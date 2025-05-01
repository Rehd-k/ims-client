import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/actions.dart';
import '../../globals/sidebar.dart';
import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
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
        floatingActionButton: smallScreen
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      // height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.all(8.0),
                      child: AddUser(updateUserList: updateUsers),
                    ),
                  );
                },
                child: Icon(Icons.add_outlined))
            : null,
        appBar: AppBar(actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined)),
          ...actions(context, themeNotifier, tokenNotifier),
          IconButton(onPressed: () {}, icon: Icon(Icons.live_help_outlined)),
        ]),
        drawer: smallScreen
            ? Drawer(
                backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                child: SideBar(tokenNotifier: tokenNotifier))
            : null,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
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
        ),
      );
    });
  }
}
