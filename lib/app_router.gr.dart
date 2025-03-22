// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;
import 'package:invease/auth/login.dart' as _i8;
import 'package:invease/screens/customers/index.dart' as _i3;
import 'package:invease/screens/dashboard/dashboard.dart' as _i4;
import 'package:invease/screens/expenses/index.dart' as _i6;
import 'package:invease/screens/makesale/checkout.dart' as _i2;
import 'package:invease/screens/makesale/index.dart' as _i10;
import 'package:invease/screens/menu.dart' as _i9;
import 'package:invease/screens/products/category/index.dart' as _i1;
import 'package:invease/screens/products/index.dart' as _i13;
import 'package:invease/screens/products/product_dashbaord/product_dashboard.dart'
    as _i12;
import 'package:invease/screens/reports/expence_reports/index.dart' as _i5;
import 'package:invease/screens/reports/income_reports/index.dart' as _i7;
import 'package:invease/screens/reports/payment_reports/index.dart' as _i11;
import 'package:invease/screens/supplier/index.dart' as _i14;
import 'package:invease/screens/user_management/users/index.dart' as _i15;

/// generated route for
/// [_i1.CategoryIndex]
class CategoryIndex extends _i16.PageRouteInfo<void> {
  const CategoryIndex({List<_i16.PageRouteInfo>? children})
    : super(CategoryIndex.name, initialChildren: children);

  static const String name = 'CategoryIndex';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.CategoryIndex();
    },
  );
}

/// generated route for
/// [_i2.CheckoutScreen]
class CheckoutRoute extends _i16.PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({
    _i17.Key? key,
    required double total,
    required List<dynamic> cart,
    required Function handleComplete,
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>();
      return _i2.CheckoutScreen(
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

  final _i17.Key? key;

  final double total;

  final List<dynamic> cart;

  final Function handleComplete;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key, total: $total, cart: $cart, handleComplete: $handleComplete}';
  }
}

/// generated route for
/// [_i3.CustomerScreen]
class CustomerRoute extends _i16.PageRouteInfo<void> {
  const CustomerRoute({List<_i16.PageRouteInfo>? children})
    : super(CustomerRoute.name, initialChildren: children);

  static const String name = 'CustomerRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i3.CustomerScreen();
    },
  );
}

/// generated route for
/// [_i4.DashboardScreen]
class DashboardRoute extends _i16.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i17.Key? key,
    dynamic Function()? onResult,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         DashboardRoute.name,
         args: DashboardRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'DashboardRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DashboardRouteArgs>(
        orElse: () => const DashboardRouteArgs(),
      );
      return _i4.DashboardScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key, this.onResult});

  final _i17.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i5.ExpencesReportScreen]
class ExpencesReportRoute extends _i16.PageRouteInfo<void> {
  const ExpencesReportRoute({List<_i16.PageRouteInfo>? children})
    : super(ExpencesReportRoute.name, initialChildren: children);

  static const String name = 'ExpencesReportRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i5.ExpencesReportScreen();
    },
  );
}

/// generated route for
/// [_i6.Expenses]
class Expenses extends _i16.PageRouteInfo<void> {
  const Expenses({List<_i16.PageRouteInfo>? children})
    : super(Expenses.name, initialChildren: children);

  static const String name = 'Expenses';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i6.Expenses();
    },
  );
}

/// generated route for
/// [_i7.IncomeReportsScreen]
class IncomeReportsRoute extends _i16.PageRouteInfo<void> {
  const IncomeReportsRoute({List<_i16.PageRouteInfo>? children})
    : super(IncomeReportsRoute.name, initialChildren: children);

  static const String name = 'IncomeReportsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.IncomeReportsScreen();
    },
  );
}

/// generated route for
/// [_i8.LoginScreen]
class LoginRoute extends _i16.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i17.Key? key,
    dynamic Function()? onResult,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i8.LoginScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final _i17.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i9.MainMenuScreen]
class MainMenuRoute extends _i16.PageRouteInfo<void> {
  const MainMenuRoute({List<_i16.PageRouteInfo>? children})
    : super(MainMenuRoute.name, initialChildren: children);

  static const String name = 'MainMenuRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.MainMenuScreen();
    },
  );
}

/// generated route for
/// [_i10.MakeSaleIndex]
class MakeSaleIndex extends _i16.PageRouteInfo<MakeSaleIndexArgs> {
  MakeSaleIndex({
    _i17.Key? key,
    dynamic Function()? onResult,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         MakeSaleIndex.name,
         args: MakeSaleIndexArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'MakeSaleIndex';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MakeSaleIndexArgs>(
        orElse: () => const MakeSaleIndexArgs(),
      );
      return _i10.MakeSaleIndex(key: args.key, onResult: args.onResult);
    },
  );
}

class MakeSaleIndexArgs {
  const MakeSaleIndexArgs({this.key, this.onResult});

  final _i17.Key? key;

  final dynamic Function()? onResult;

  @override
  String toString() {
    return 'MakeSaleIndexArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i11.PaymentReportsScreen]
class PaymentReportsRoute extends _i16.PageRouteInfo<void> {
  const PaymentReportsRoute({List<_i16.PageRouteInfo>? children})
    : super(PaymentReportsRoute.name, initialChildren: children);

  static const String name = 'PaymentReportsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i11.PaymentReportsScreen();
    },
  );
}

/// generated route for
/// [_i12.ProductDashboard]
class ProductDashboard extends _i16.PageRouteInfo<ProductDashboardArgs> {
  ProductDashboard({
    _i17.Key? key,
    String? productId,
    String? productName,
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDashboardArgs>(
        orElse: () => const ProductDashboardArgs(),
      );
      return _i12.ProductDashboard(
        key: args.key,
        productId: args.productId,
        productName: args.productName,
      );
    },
  );
}

class ProductDashboardArgs {
  const ProductDashboardArgs({this.key, this.productId, this.productName});

  final _i17.Key? key;

  final String? productId;

  final String? productName;

  @override
  String toString() {
    return 'ProductDashboardArgs{key: $key, productId: $productId, productName: $productName}';
  }
}

/// generated route for
/// [_i13.ProductsIndex]
class ProductsIndex extends _i16.PageRouteInfo<void> {
  const ProductsIndex({List<_i16.PageRouteInfo>? children})
    : super(ProductsIndex.name, initialChildren: children);

  static const String name = 'ProductsIndex';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProductsIndex();
    },
  );
}

/// generated route for
/// [_i14.SupplierIndex]
class SupplierIndex extends _i16.PageRouteInfo<void> {
  const SupplierIndex({List<_i16.PageRouteInfo>? children})
    : super(SupplierIndex.name, initialChildren: children);

  static const String name = 'SupplierIndex';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i14.SupplierIndex();
    },
  );
}

/// generated route for
/// [_i15.UserManagementScreen]
class UserManagementRoute extends _i16.PageRouteInfo<void> {
  const UserManagementRoute({List<_i16.PageRouteInfo>? children})
    : super(UserManagementRoute.name, initialChildren: children);

  static const String name = 'UserManagementRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i15.UserManagementScreen();
    },
  );
}
