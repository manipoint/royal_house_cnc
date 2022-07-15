import 'dart:convert';

import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../const /app_const_variables.dart';
import '../../../../models/user_model.dart';
import '../../../../util/custom_snackbar.dart';

class ProductDetailService {
  Future<void> addToCart({
    required BuildContext context,
    required ProductModel productModel,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': productModel.id!}),
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            UserModel userModel = userProvider.user
                .copyWith(cart: jsonDecode(response.body)['cart']);
            userProvider.setUserFromModel(userModel);
            showSnackBar(context, "${productModel.name} added to cart ");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required ProductModel productModel,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': productModel.id!,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showSnackBar(context, e.toString());
    }
  }
}
