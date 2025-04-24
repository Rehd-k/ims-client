import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
import 'helpers/auth_guards/logedin_guard.dart';
import 'helpers/auth_guards/login_gaurd.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  bool isWindows = true;
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, keepHistory: false, initial: true),
        AutoRoute(
            page: LoginRoute.page,
            keepHistory: false,
            initial: isWindows ? false : true,
            guards: [LoginGaurd()]),
        AutoRoute(page: ErrorRoute.page),
        AutoRoute(path: '/', page: MainMenuRoute.page, children: [
          AutoRoute(
              path: 'dashboard',
              page: DashboardRoute.page,
              guards: [LogedinGuard()]),
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
          AutoRoute(path: 'banks', page: BankRoute.page),
          AutoRoute(path: 'create_invoice', page: AddInvoice.page),
          AutoRoute(path: 'view_invoices', page: ViewInvoices.page),
        ]),
      ];
}
