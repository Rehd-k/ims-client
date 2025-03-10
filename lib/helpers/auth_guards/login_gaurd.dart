import 'package:auto_route/auto_route.dart';

class LoginGaurd extends AutoRouteGuard {
  final Map? decodedToken;
  LoginGaurd({required this.decodedToken});
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (decodedToken != null && decodedToken?['role'] == 'admin') {
      router.pushNamed('/dashboard');
    } else if (decodedToken != null && decodedToken?['role'] == 'cashier') {
      router.pushNamed('/dashboard');
    } else {
      resolver.next(true);
    }
  }
}
