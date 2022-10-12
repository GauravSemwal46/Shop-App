import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/app_colors.dart';
import 'package:flutter_shop_app/helpers/constants.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(AppConstants.confirmationText),
            content: const Text(AppConstants.deleteConfirmationText),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(AppConstants.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(AppConstants.yes),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: AppColors.whiteColor,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('${AppConstants.total}: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
