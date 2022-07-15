import 'dart:convert';

import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/pages/auth/screens/auth_page.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/custom_snackbar.dart';

class ProfileService {
  Future<List<OrderModel>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<OrderModel> orderList = [];
    try {
      http.Response response =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
  
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            orderList.add(
              OrderModel.fromJson(
                jsonEncode(
                  jsonDecode(response.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("x-auth-token", '').then((value) =>
          Navigator.pushNamedAndRemoveUntil(
              context, AuthPage.routeName, (route) => false));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
