import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/product_details_screen.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';

class AppRoutes {
  static const productDetailRoute = '/product-details';
  static const cartRoute = '/cart';
  static const ordersRoute = '/orders';
  static const userProductRoute = '/user-products';
  static const editProductRoute = '/edit-product';

  static Map<String, Widget Function(BuildContext)> routeConfig = {
    productDetailRoute: (_) => const ProductDetailsScreen(),
    cartRoute: (_) => const CartScreen(),
    ordersRoute: (_) => const OrdersScreen(),
    userProductRoute: (_) => const UserProductsScreen(),
    editProductRoute: (_) => const EditProductScreen(),
  };
}
