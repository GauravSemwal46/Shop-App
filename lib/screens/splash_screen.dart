import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppConstants.loading),
      ),
    );
  }
}
