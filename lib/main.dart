import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/helpers/app_colors.dart';
import 'package:flutter_shop_app/helpers/constants.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/screens/product_details_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: (ctx, auth, previousProducts) => Orders(auth.token ?? '',
                auth.userId ?? '', previousProducts?.orders ?? [])),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.myShop,
          theme: ThemeData(
            primarySwatch: AppColors.darkPurpleColor,
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: AppColors.darkPurpleColor)
                    .copyWith(secondary: AppColors.deepOrangeColor),
            fontFamily: AppConstants.lato,
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: ((context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
                ),
          routes: {
            ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductsScreen.routeName: (_) => const UserProductsScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
