import 'package:auto_route/auto_route.dart';

import '../../services/token.service.dart';

class LoginGaurd extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final decodeToken = JwtService().decodedToken;

    if (decodeToken != null && decodeToken['role'] == 'admin') {
      router.replacePath('/dashboard');
    } else if (decodeToken != null && decodeToken['role'] == 'cashier') {
      router.replacePath('/make-sale');
    } else {
      resolver.next(true);
    }
  }
}
