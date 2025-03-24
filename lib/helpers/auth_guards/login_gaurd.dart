import 'package:auto_route/auto_route.dart';

import '../../services/token.service.dart';

class LoginGaurd extends AutoRouteGuard {
  final JwtService _jwtService = JwtService();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    Map? decodeToken;
    final token = await _jwtService.getToken();
    if (token != null) {
      decodeToken = _jwtService.decodeToken(token);
    }
    if (decodeToken != null && decodeToken['role'] == 'admin') {
      router.replacePath('/dashboard');
    } else if (decodeToken != null && decodeToken['role'] == 'cashier') {
      router.replacePath('/make-sale');
    } else {
      resolver.next(true);
    }
  }
}
