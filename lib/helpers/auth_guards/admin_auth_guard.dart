import 'package:auto_route/auto_route.dart';

import '../../app_router.gr.dart';

class AdminAuthGuard extends AutoRouteGuard {
  final Map? decodedToken;
  AdminAuthGuard({required this.decodedToken});
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (decodedToken != null) {
      if (decodedToken?['role'] == 'admin') {
        router.push(DashboardRoute(onResult: () {
          resolver.next(true);
        }));
      } else if (decodedToken?['role'] == 'cashier') {
        router.push(MakeSaleIndex(onResult: () {
          resolver.next(true);
        }));
      } else {
        router.push(LoginRoute(onResult: () {
          resolver.next(true);
        }));
      }
    }
  }
}
