import 'package:auto_route/auto_route.dart';

import '../../app_router.gr.dart';
import '../../services/token.service.dart';

class AdminAuthGuard extends AutoRouteGuard {
  final Map? decodedToken;
  final JwtService _jwtService = JwtService();
  AdminAuthGuard({required this.decodedToken});
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    Map? decodeToken = await _jwtService.checkToken();

    if (decodeToken != null) {
      if (decodeToken['role'] == 'admin') {
        router.push(DashboardRoute(onResult: () {
          resolver.next(true);
        }));
      } else if (decodeToken['role'] == 'cashier') {
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
