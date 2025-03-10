import 'package:auto_route/auto_route.dart';

import '../../app_router.gr.dart';

class LogedinGuard extends AutoRouteGuard {
  final Map? decodedToken;
  LogedinGuard({required this.decodedToken});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (decodedToken != null) {
      if (decodedToken?['role'] == 'admin') {
        resolver.next(true); // Allow navigation
      } else if (decodedToken?['role'] == 'cashier') {
        resolver
            .redirect(MakeSaleIndex()); // Redirect instead of pushing manually
      } else {
        resolver.redirect(LoginRoute()); // Redirect to login for unknown roles
      }
    } else {
      resolver.redirect(LoginRoute());
    }
  }
}
