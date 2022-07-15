import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class TotalCartPrice extends StatelessWidget {
  const TotalCartPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width / (width / 10), vertical: height / (height / 10)),
      child: Row(
        children: [
          Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: height / (height / 20),
            ),
          ),
          Text(
            'Rs $sum',
            style: TextStyle(
              fontSize: height / (height / 20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
