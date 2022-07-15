import 'dart:convert';

import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../util/custom_snackbar.dart';

class HomeService {
  Future<List<ProductModel>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductModel> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              ProductModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<ProductModel> getDealOfTheDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ProductModel productModel = ProductModel(
        name: '',
        description: '',
        quantity: 0.0,
        images: [],
        category: '',
        price: 0.0);
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/deal-of-day"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          productModel = ProductModel.fromJson(response.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productModel;
  }
}
