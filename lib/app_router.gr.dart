// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/material.dart' as _i22;
import 'package:invease/auth/login.dart' as _i11;
import 'package:invease/screens/banks/index.dart' as _i2;
import 'package:invease/screens/customers/index.dart' as _i5;
import 'package:invease/screens/dashboard/dashboard.dart' as _i6;
import 'package:invease/screens/errors/errors.dart' as _i7;
import 'package:invease/screens/expenses/index.dart' as _i9;
import 'package:invease/screens/invoice/add_invoice.dart' as _i1;
import 'package:invease/screens/invoice/view_invoices.dart' as _i20;
import 'package:invease/screens/makesale/checkout.dart' as _i4;
import 'package:invease/screens/makesale/index.dart' as _i13;
import 'package:invease/screens/menu.dart' as _i12;
import 'package:invease/screens/products/category/index.dart' as _i3;
import 'package:invease/screens/products/index.dart' as _i16;
import 'package:invease/screens/products/product_dashbaord/product_dashboard.dart'
    as _i15;
import 'package:invease/screens/reports/expence_reports/index.dart' as _i8;
import 'package:invease/screens/reports/income_reports/index.dart' as _i10;
import 'package:invease/screens/reports/payment_reports/index.dart' as _i14;
import 'package:invease/screens/splashscreen.dart' as _i17;
import 'package:invease/screens/supplier/index.dart' as _i18;
import 'package:invease/screens/users/index.dart' as _i19;

/// generated route for
/// [_i1.AddInvoice]
class AddInvoice extends _i21.PageRouteInfo<void> {
  const AddInvoice({List<_i21.PageRouteInfo>? children})
    : super(AddInvoice.name, initialChildren: children);

  static const String name = 'AddInvoice';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddInvoice();
    },
  );
}

/// generated route for
/// [_i2.BankScreen]
class BankRoute extends _i21.PageRouteInfo<void> {
  const BankRoute({List<_i21.PageRouteInfo>? children})
    : super(BankRoute.name, initialChildren: children);

  static const String name = 'BankRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i2.BankScreen();
    },
  );
}

/// generated route for
/// [_i3.CategoryIndex]
class CategoryIndex extends _i21.PageRouteInfo<void> {
  const CategoryIndex({List<_i21.PageRouteInfo>? children})
    : super(CategoryIndex.name, initialChildren: children);

  static const String name = 'CategoryIndex';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i3.CategoryIndex();
    },
  );
}

/// generated route for
/// [_i4.CheckoutScreen]
class CheckoutRoute extends _i21.PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({
    _i22.Key? key,
    required double total,
    required List<dynamic> cart,
    required Function handleComplete,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         CheckoutRoute.name,
         args: CheckoutRouteArgs(
           key: key,
           total: total,
           cart: cart,
           handleComplete: handleComplete,
         ),
         initialChildren: children,
       );

  static const String name = 'CheckoutRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>();
      return _i4.CheckoutScreen(
        key: args.key,
        total: args.total,
        cart: args.cart,
        handleComplete: args.handleComplete,
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
  });

  final _i22.Key? key;

  final double total;

  final List<dynamic> cart;

  final Function handleComplete;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key, total: $total, cart: $cart, handleComplete: $handleComplete}';
  }
}

/// generated route for
/// [_i5.CustomerScreen]
class CustomerRoute extends _i21.PageRouteInfo<void> {
  const CustomerRoute({List<_i21.PageRouteInfo>? children})
    : super(CustomerRoute.name, initialChildren: children);

  static const String name = 'CustomerRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i5.CustomerScreen();
    },
  );
}

/// generated route for
/// [_i6.DashboardScreen]
class DashboardRoute extends _i21.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i22.Key? key,
    dynamic Function()? onResult,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         DashboardRoute.name,
         args: DashboardRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'DashboardRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DashboardRouteArgs>(
        orElse: () => const DashboardRouteArgs(),
      );
      return _i6.DashboardScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key, this.onResult});

  final _i22.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i7.ErrorScreen]
class ErrorRoute extends _i21.PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    _i22.Key? key,
    _i22.VoidCallback? onRetry,
    Map<dynamic, dynamic>? details,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         ErrorRoute.name,
         args: ErrorRouteArgs(key: key, onRetry: onRetry, details: details),
         initialChildren: children,
       );

  static const String name = 'ErrorRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ErrorRouteArgs>(
        orElse: () => const ErrorRouteArgs(),
      );
      return _i7.ErrorScreen(
        key: args.key,
        onRetry: args.onRetry,
        details: args.details,
      );
    },
  );
}

class ErrorRouteArgs {
  const ErrorRouteArgs({this.key, this.onRetry, this.details});

  final _i22.Key? key;

  final _i22.VoidCallback? onRetry;

  final Map<dynamic, dynamic>? details;

  @override
  String toString() {
    return 'ErrorRouteArgs{key: $key, onRetry: $onRetry, details: $details}';
  }
}

/// generated route for
/// [_i8.ExpencesReportScreen]
class ExpencesReportRoute extends _i21.PageRouteInfo<void> {
  const ExpencesReportRoute({List<_i21.PageRouteInfo>? children})
    : super(ExpencesReportRoute.name, initialChildren: children);

  static const String name = 'ExpencesReportRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i8.ExpencesReportScreen();
    },
  );
}

/// generated route for
/// [_i9.Expenses]
class Expenses extends _i21.PageRouteInfo<void> {
  const Expenses({List<_i21.PageRouteInfo>? children})
    : super(Expenses.name, initialChildren: children);

  static const String name = 'Expenses';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i9.Expenses();
    },
  );
}

/// generated route for
/// [_i10.IncomeReportsScreen]
class IncomeReportsRoute extends _i21.PageRouteInfo<void> {
  const IncomeReportsRoute({List<_i21.PageRouteInfo>? children})
    : super(IncomeReportsRoute.name, initialChildren: children);

  static const String name = 'IncomeReportsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i10.IncomeReportsScreen();
    },
  );
}

/// generated route for
/// [_i11.LoginScreen]
class LoginRoute extends _i21.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i22.Key? key,
    dynamic Function()? onResult,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i11.LoginScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final _i22.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i12.MainMenuScreen]
class MainMenuRoute extends _i21.PageRouteInfo<void> {
  const MainMenuRoute({List<_i21.PageRouteInfo>? children})
    : super(MainMenuRoute.name, initialChildren: children);

  static const String name = 'MainMenuRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i12.MainMenuScreen();
    },
  );
}

/// generated route for
/// [_i13.MakeSaleIndex]
class MakeSaleIndex extends _i21.PageRouteInfo<MakeSaleIndexArgs> {
  MakeSaleIndex({
    _i22.Key? key,
    dynamic Function()? onResult,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         MakeSaleIndex.name,
         args: MakeSaleIndexArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'MakeSaleIndex';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MakeSaleIndexArgs>(
        orElse: () => const MakeSaleIndexArgs(),
      );
      return _i13.MakeSaleIndex(key: args.key, onResult: args.onResult);
    },
  );
}

class MakeSaleIndexArgs {
  const MakeSaleIndexArgs({this.key, this.onResult});

  final _i22.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'MakeSaleIndexArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i14.PaymentReportsScreen]
class PaymentReportsRoute extends _i21.PageRouteInfo<void> {
  const PaymentReportsRoute({List<_i21.PageRouteInfo>? children})
    : super(PaymentReportsRoute.name, initialChildren: children);

  static const String name = 'PaymentReportsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i14.PaymentReportsScreen();
    },
  );
}

/// generated route for
/// [_i15.ProductDashboard]
class ProductDashboard extends _i21.PageRouteInfo<ProductDashboardArgs> {
  ProductDashboard({
    _i22.Key? key,
    String? productId,
    String? productName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         ProductDashboard.name,
         args: ProductDashboardArgs(
           key: key,
           productId: productId,
           productName: productName,
         ),
         initialChildren: children,
       );

  static const String name = 'ProductDashboard';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDashboardArgs>(
        orElse: () => const ProductDashboardArgs(),
      );
      return _i15.ProductDashboard(
        key: args.key,
        productId: args.productId,
        productName: args.productName,
      );
    },
  );
}

class ProductDashboardArgs {
  const ProductDashboardArgs({this.key, this.productId, this.productName});

  final _i22.Key? key;

  final String? productId;

  final String? productName;

  @override
  String toString() {
    return 'ProductDashboardArgs{key: $key, productId: $productId, productName: $productName}';
  }
}

/// generated route for
/// [_i16.ProductsIndex]
class ProductsIndex extends _i21.PageRouteInfo<void> {
  const ProductsIndex({List<_i21.PageRouteInfo>? children})
    : super(ProductsIndex.name, initialChildren: children);

  static const String name = 'ProductsIndex';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i16.ProductsIndex();
    },
  );
}

/// generated route for
/// [_i17.SplashScreen]
class SplashRoute extends _i21.PageRouteInfo<void> {
  const SplashRoute({List<_i21.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i17.SplashScreen();
    },
  );
}

/// generated route for
/// [_i18.SupplierIndex]
class SupplierIndex extends _i21.PageRouteInfo<void> {
  const SupplierIndex({List<_i21.PageRouteInfo>? children})
    : super(SupplierIndex.name, initialChildren: children);

  static const String name = 'SupplierIndex';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i18.SupplierIndex();
    },
  );
}

/// generated route for
/// [_i19.UserManagementScreen]
class UserManagementRoute extends _i21.PageRouteInfo<void> {
  const UserManagementRoute({List<_i21.PageRouteInfo>? children})
    : super(UserManagementRoute.name, initialChildren: children);

  static const String name = 'UserManagementRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i19.UserManagementScreen();
    },
  );
}

/// generated route for
/// [_i20.ViewInvoices]
class ViewInvoices extends _i21.PageRouteInfo<void> {
  const ViewInvoices({List<_i21.PageRouteInfo>? children})
    : super(ViewInvoices.name, initialChildren: children);

  static const String name = 'ViewInvoices';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i20.ViewInvoices();
    },
  );
}
