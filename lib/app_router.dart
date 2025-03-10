import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
import 'helpers/auth_guards/logedin_guard.dart';
import 'helpers/auth_guards/login_gaurd.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final Map? decodedToken;
  AppRouter({required this.decodedToken});
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: LoginRoute.page,
            keepHistory: false,
            initial: true,
            guards: [LoginGaurd(decodedToken: decodedToken)]),
        AutoRoute(path: '/', page: MainMenuRoute.page, children: [
          AutoRoute(
              path: 'dashboard',
              page: DashboardRoute.page,
              guards: [LogedinGuard(decodedToken: decodedToken)]),
          AutoRoute(path: 'users', page: UserManagementRoute.page),
          AutoRoute(
            path: 'products',
            page: ProductsIndex.page,
          ),
          AutoRoute(page: ProductDashboard.page, path: 'product-dashboard'),
          AutoRoute(path: 'customers', page: CustomerRoute.page),
          AutoRoute(path: 'categories', page: CategoryIndex.page),
          AutoRoute(path: 'suppliers', page: SupplierIndex.page),
          AutoRoute(path: 'make-sale', page: MakeSaleIndex.page),
          AutoRoute(path: 'checkout', page: CheckoutRoute.page),
          AutoRoute(path: 'payment_report', page: PaymentReportsRoute.page),
          AutoRoute(path: 'income_report', page: IncomeReportsRoute.page),
          AutoRoute(path: 'expenses_report', page: ExpencesReportRoute.page),
          AutoRoute(path: 'expenses', page: Expenses.page),
        ]),
      ];
}
