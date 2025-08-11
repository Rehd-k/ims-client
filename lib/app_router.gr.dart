// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i24;
import 'package:flutter/material.dart' as _i25;
import 'package:shelf_sense/auth/login.dart' as _i14;
import 'package:shelf_sense/screens/banks/index.dart' as _i2;
import 'package:shelf_sense/screens/charges/index.dart' as _i4;
import 'package:shelf_sense/screens/customers/dashbaord/index.dart' as _i6;
import 'package:shelf_sense/screens/customers/index.dart' as _i7;
import 'package:shelf_sense/screens/dashboard/dashboard.dart' as _i8;
import 'package:shelf_sense/screens/errors/errors.dart' as _i9;
import 'package:shelf_sense/screens/expenses/index.dart' as _i11;
import 'package:shelf_sense/screens/invoice/add_invoice.dart' as _i1;
import 'package:shelf_sense/screens/invoice/view_invoices.dart' as _i23;
import 'package:shelf_sense/screens/locations/index.dart' as _i13;
import 'package:shelf_sense/screens/makesale/checkout.dart' as _i5;
import 'package:shelf_sense/screens/makesale/index.dart' as _i16;
import 'package:shelf_sense/screens/menu.dart' as _i15;
import 'package:shelf_sense/screens/products/category/index.dart' as _i3;
import 'package:shelf_sense/screens/products/index.dart' as _i19;
import 'package:shelf_sense/screens/products/product_dashbaord/product_dashboard.dart'
    as _i18;
import 'package:shelf_sense/screens/reports/expence_reports/index.dart' as _i10;
import 'package:shelf_sense/screens/reports/income_reports/index.dart' as _i12;
import 'package:shelf_sense/screens/reports/payment_reports/index.dart' as _i17;
import 'package:shelf_sense/screens/splashscreen.dart' as _i20;
import 'package:shelf_sense/screens/supplier/index.dart' as _i21;
import 'package:shelf_sense/screens/users/index.dart' as _i22;

/// generated route for
/// [_i1.AddInvoice]
class AddInvoice extends _i24.PageRouteInfo<void> {
  const AddInvoice({List<_i24.PageRouteInfo>? children})
    : super(AddInvoice.name, initialChildren: children);

  static const String name = 'AddInvoice';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddInvoice();
    },
  );
}

/// generated route for
/// [_i2.BankScreen]
class BankRoute extends _i24.PageRouteInfo<void> {
  const BankRoute({List<_i24.PageRouteInfo>? children})
    : super(BankRoute.name, initialChildren: children);

  static const String name = 'BankRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i2.BankScreen();
    },
  );
}

/// generated route for
/// [_i3.CategoryScreen]
class CategoryRoute extends _i24.PageRouteInfo<void> {
  const CategoryRoute({List<_i24.PageRouteInfo>? children})
    : super(CategoryRoute.name, initialChildren: children);

  static const String name = 'CategoryRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i3.CategoryScreen();
    },
  );
}

/// generated route for
/// [_i4.ChargesScreen]
class ChargesRoute extends _i24.PageRouteInfo<void> {
  const ChargesRoute({List<_i24.PageRouteInfo>? children})
    : super(ChargesRoute.name, initialChildren: children);

  static const String name = 'ChargesRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i4.ChargesScreen();
    },
  );
}

/// generated route for
/// [_i5.CheckoutScreen]
class CheckoutRoute extends _i24.PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({
    _i25.Key? key,
    required double total,
    required List<dynamic> cart,
    required Function handleComplete,
    Map<dynamic, dynamic>? selectedBank,
    Map<dynamic, dynamic>? selectedUser,
    num? discount,
    String? invoiceId,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         CheckoutRoute.name,
         args: CheckoutRouteArgs(
           key: key,
           total: total,
           cart: cart,
           handleComplete: handleComplete,
           selectedBank: selectedBank,
           selectedUser: selectedUser,
           discount: discount,
           invoiceId: invoiceId,
         ),
         initialChildren: children,
       );

  static const String name = 'CheckoutRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>();
      return _i5.CheckoutScreen(
        key: args.key,
        total: args.total,
        cart: args.cart,
        handleComplete: args.handleComplete,
        selectedBank: args.selectedBank,
        selectedUser: args.selectedUser,
        discount: args.discount,
        invoiceId: args.invoiceId,
      );
    },
  );
}

class CheckoutRouteArgs {
  const CheckoutRouteArgs({
    this.key,
    required this.total,
    required this.cart,
    required this.handleComplete,
    this.selectedBank,
    this.selectedUser,
    this.discount,
    this.invoiceId,
  });

  final _i25.Key? key;

  final double total;

  final List<dynamic> cart;

  final Function handleComplete;

  final Map<dynamic, dynamic>? selectedBank;

  final Map<dynamic, dynamic>? selectedUser;

  final num? discount;

  final String? invoiceId;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key, total: $total, cart: $cart, handleComplete: $handleComplete, selectedBank: $selectedBank, selectedUser: $selectedUser, discount: $discount, invoiceId: $invoiceId}';
  }
}

/// generated route for
/// [_i6.CustomerDetails]
class CustomerDetails extends _i24.PageRouteInfo<CustomerDetailsArgs> {
  CustomerDetails({
    _i25.Key? key,
    required Map<dynamic, dynamic> customer,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         CustomerDetails.name,
         args: CustomerDetailsArgs(key: key, customer: customer),
         initialChildren: children,
       );

  static const String name = 'CustomerDetails';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CustomerDetailsArgs>();
      return _i6.CustomerDetails(key: args.key, customer: args.customer);
    },
  );
}

class CustomerDetailsArgs {
  const CustomerDetailsArgs({this.key, required this.customer});

  final _i25.Key? key;

  final Map<dynamic, dynamic> customer;

  @override
  String toString() {
    return 'CustomerDetailsArgs{key: $key, customer: $customer}';
  }
}

/// generated route for
/// [_i7.CustomerScreen]
class CustomerRoute extends _i24.PageRouteInfo<void> {
  const CustomerRoute({List<_i24.PageRouteInfo>? children})
    : super(CustomerRoute.name, initialChildren: children);

  static const String name = 'CustomerRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i7.CustomerScreen();
    },
  );
}

/// generated route for
/// [_i8.DashboardScreen]
class DashboardRoute extends _i24.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i25.Key? key,
    dynamic Function()? onResult,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         DashboardRoute.name,
         args: DashboardRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'DashboardRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DashboardRouteArgs>(
        orElse: () => const DashboardRouteArgs(),
      );
      return _i8.DashboardScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key, this.onResult});

  final _i25.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i9.ErrorScreen]
class ErrorRoute extends _i24.PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    _i25.Key? key,
    _i25.VoidCallback? onRetry,
    Map<dynamic, dynamic>? details,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         ErrorRoute.name,
         args: ErrorRouteArgs(key: key, onRetry: onRetry, details: details),
         initialChildren: children,
       );

  static const String name = 'ErrorRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ErrorRouteArgs>(
        orElse: () => const ErrorRouteArgs(),
      );
      return _i9.ErrorScreen(
        key: args.key,
        onRetry: args.onRetry,
        details: args.details,
      );
    },
  );
}

class ErrorRouteArgs {
  const ErrorRouteArgs({this.key, this.onRetry, this.details});

  final _i25.Key? key;

  final _i25.VoidCallback? onRetry;

  final Map<dynamic, dynamic>? details;

  @override
  String toString() {
    return 'ErrorRouteArgs{key: $key, onRetry: $onRetry, details: $details}';
  }
}

/// generated route for
/// [_i10.ExpencesReportScreen]
class ExpencesReportRoute extends _i24.PageRouteInfo<void> {
  const ExpencesReportRoute({List<_i24.PageRouteInfo>? children})
    : super(ExpencesReportRoute.name, initialChildren: children);

  static const String name = 'ExpencesReportRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i10.ExpencesReportScreen();
    },
  );
}

/// generated route for
/// [_i11.Expenses]
class Expenses extends _i24.PageRouteInfo<void> {
  const Expenses({List<_i24.PageRouteInfo>? children})
    : super(Expenses.name, initialChildren: children);

  static const String name = 'Expenses';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i11.Expenses();
    },
  );
}

/// generated route for
/// [_i12.IncomeReportsScreen]
class IncomeReportsRoute extends _i24.PageRouteInfo<void> {
  const IncomeReportsRoute({List<_i24.PageRouteInfo>? children})
    : super(IncomeReportsRoute.name, initialChildren: children);

  static const String name = 'IncomeReportsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i12.IncomeReportsScreen();
    },
  );
}

/// generated route for
/// [_i13.LocationIndex]
class LocationIndex extends _i24.PageRouteInfo<void> {
  const LocationIndex({List<_i24.PageRouteInfo>? children})
    : super(LocationIndex.name, initialChildren: children);

  static const String name = 'LocationIndex';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i13.LocationIndex();
    },
  );
}

/// generated route for
/// [_i14.LoginScreen]
class LoginRoute extends _i24.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i25.Key? key,
    dynamic Function()? onResult,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i14.LoginScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final _i25.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i15.MainMenuScreen]
class MainMenuRoute extends _i24.PageRouteInfo<void> {
  const MainMenuRoute({List<_i24.PageRouteInfo>? children})
    : super(MainMenuRoute.name, initialChildren: children);

  static const String name = 'MainMenuRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i15.MainMenuScreen();
    },
  );
}

/// generated route for
/// [_i16.MakeSaleScreen]
class MakeSaleRoute extends _i24.PageRouteInfo<MakeSaleRouteArgs> {
  MakeSaleRoute({
    _i25.Key? key,
    dynamic Function()? onResult,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         MakeSaleRoute.name,
         args: MakeSaleRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'MakeSaleRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MakeSaleRouteArgs>(
        orElse: () => const MakeSaleRouteArgs(),
      );
      return _i16.MakeSaleScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class MakeSaleRouteArgs {
  const MakeSaleRouteArgs({this.key, this.onResult});

  final _i25.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'MakeSaleRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i17.PaymentReportsScreen]
class PaymentReportsRoute extends _i24.PageRouteInfo<void> {
  const PaymentReportsRoute({List<_i24.PageRouteInfo>? children})
    : super(PaymentReportsRoute.name, initialChildren: children);

  static const String name = 'PaymentReportsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i17.PaymentReportsScreen();
    },
  );
}

/// generated route for
/// [_i18.ProductDashboard]
class ProductDashboard extends _i24.PageRouteInfo<ProductDashboardArgs> {
  ProductDashboard({
    _i25.Key? key,
    String? productId,
    String? productName,
    required String type,
    String? cartonAmount,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         ProductDashboard.name,
         args: ProductDashboardArgs(
           key: key,
           productId: productId,
           productName: productName,
           type: type,
           cartonAmount: cartonAmount,
         ),
         initialChildren: children,
       );

  static const String name = 'ProductDashboard';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDashboardArgs>();
      return _i18.ProductDashboard(
        key: args.key,
        productId: args.productId,
        productName: args.productName,
        type: args.type,
        cartonAmount: args.cartonAmount,
      );
    },
  );
}

class ProductDashboardArgs {
  const ProductDashboardArgs({
    this.key,
    this.productId,
    this.productName,
    required this.type,
    this.cartonAmount,
  });

  final _i25.Key? key;

  final String? productId;

  final String? productName;

  final String type;

  final String? cartonAmount;

  @override
  String toString() {
    return 'ProductDashboardArgs{key: $key, productId: $productId, productName: $productName, type: $type, cartonAmount: $cartonAmount}';
  }
}

/// generated route for
/// [_i19.ProductsScreen]
class ProductsRoute extends _i24.PageRouteInfo<void> {
  const ProductsRoute({List<_i24.PageRouteInfo>? children})
    : super(ProductsRoute.name, initialChildren: children);

  static const String name = 'ProductsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i19.ProductsScreen();
    },
  );
}

/// generated route for
/// [_i20.SplashScreen]
class SplashRoute extends _i24.PageRouteInfo<void> {
  const SplashRoute({List<_i24.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i20.SplashScreen();
    },
  );
}

/// generated route for
/// [_i21.SupplierScreen]
class SupplierRoute extends _i24.PageRouteInfo<void> {
  const SupplierRoute({List<_i24.PageRouteInfo>? children})
    : super(SupplierRoute.name, initialChildren: children);

  static const String name = 'SupplierRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i21.SupplierScreen();
    },
  );
}

/// generated route for
/// [_i22.UserManagementScreen]
class UserManagementRoute extends _i24.PageRouteInfo<void> {
  const UserManagementRoute({List<_i24.PageRouteInfo>? children})
    : super(UserManagementRoute.name, initialChildren: children);

  static const String name = 'UserManagementRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i22.UserManagementScreen();
    },
  );
}

/// generated route for
/// [_i23.ViewInvoices]
class ViewInvoices extends _i24.PageRouteInfo<ViewInvoicesArgs> {
  ViewInvoices({
    _i25.Key? key,
    String? invoiceId,
    List<_i24.PageRouteInfo>? children,
  }) : super(
         ViewInvoices.name,
         args: ViewInvoicesArgs(key: key, invoiceId: invoiceId),
         initialChildren: children,
       );

  static const String name = 'ViewInvoices';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewInvoicesArgs>(
        orElse: () => const ViewInvoicesArgs(),
      );
      return _i23.ViewInvoices(key: args.key, invoiceId: args.invoiceId);
    },
  );
}

class ViewInvoicesArgs {
  const ViewInvoicesArgs({this.key, this.invoiceId});

  final _i25.Key? key;

  final String? invoiceId;

  @override
  String toString() {
    return 'ViewInvoicesArgs{key: $key, invoiceId: $invoiceId}';
  }
}
