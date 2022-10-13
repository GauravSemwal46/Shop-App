import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/constants.dart';
import 'package:flutter_shop_app/helpers/routes.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(AppConstants.drawerTitle),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text(AppConstants.shop),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(AppConstants.orders),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.ordersRoute),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(AppConstants.manageProduct),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.userProductRoute),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppConstants.logout),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
