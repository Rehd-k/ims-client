import 'package:auto_route/auto_route.dart';

import '../../app_router.gr.dart';
import '../../services/token.service.dart';

class LogedinGuard extends AutoRouteGuard {
  final JwtService _jwtService = JwtService();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    Map? decodeToken;
    decodeToken = await _jwtService.checkToken();
    if (decodeToken != null) {
      if (decodeToken['role'] == 'admin') {
        resolver.next(true); // Allow navigation
      } else if (decodeToken['role'] == 'cashier') {
        router.replaceAll([MakeSaleIndex()]);
      } else {
        resolver.redirectUntil(LoginRoute());
      }
    } else {
      resolver.redirectUntil(LoginRoute());
    }
  }
}
