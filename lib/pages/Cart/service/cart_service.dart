import 'dart:convert';

import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../const /app_const_variables.dart';

class CartService {
  void removeFromCart(
      {required BuildContext context,
      required ProductModel productModel}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/remove-from-cart/${productModel.id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            UserModel userModel = userProvider.user
                .copyWith(cart: jsonDecode(response.body)['cart']);
            userProvider.setUserFromModel(userModel);
            showSnackBar(context, "${productModel.name} removed from cart");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
