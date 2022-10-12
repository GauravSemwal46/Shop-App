import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/constants.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.yourProducts),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: Consumer<Products>(
                builder: (ctx, productData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemBuilder: (_, index) => Column(
                      children: [
                        UserProductItem(
                          id: productData.items[index].id,
                          title: productData.items[index].title,
                          imageUrl: productData.items[index].imageUrl,
                        ),
                        const Divider(),
                      ],
                    ),
                    itemCount: productData.items.length,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
