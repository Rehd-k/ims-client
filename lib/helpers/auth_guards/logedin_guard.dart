import 'package:auto_route/auto_route.dart';

import '../../app_router.gr.dart';
import '../../services/token.service.dart';

class LogedinGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    Map? decodeToken;
    decodeToken = JwtService().decodedToken;

    if (decodeToken != null) {
      if (decodeToken['role'] == 'admin') {
        resolver.next(true); // Allow navigation
      } else if (decodeToken['role'] == 'cashier') {
        router.replaceAll([MakeSaleRoute()]);
      } else {
        resolver.redirectUntil(LoginRoute());
      }
    } else {
      resolver.redirectUntil(LoginRoute());
    }
  }
}
