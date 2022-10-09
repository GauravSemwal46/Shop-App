import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart' show Orders;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _orderFuture;

  Future _obtainFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    _orderFuture = _obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error occured!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) {
                    return ListView.builder(
                      itemBuilder: (ctx, index) =>
                          OrderItem(order: orderData.orders[index]),
                      itemCount: orderData.orders.length,
                    );
                  },
                );
              }
            }
          }),
    );
  }
}
