import 'dart:math';

import 'package:flutter_shop_app/helpers/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 135, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm a').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 40, 180)
                : 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              height: min(widget.order.products.length * 20.0 + 40, 180),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.products[i].quantity} x \$${widget.order.products[i].price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.greyColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
