import 'dart:convert';

import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../const /app_const_variables.dart';
import '../../../providers/user_provider.dart';
import '../../../util/custom_snackbar.dart';

class AddressService {
  Future<void> saveUserAddress({
    required BuildContext context,
    required AddressModel address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: address.toJson());

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            UserModel user = userProvider.user.copyWith(
              address: AddressModel.fromMap(
                  jsonDecode(response.body)['address'] as Map<String, dynamic>),
            );
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> paymentSheet({
    required BuildContext context,
    required int amount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
   
    http.Response response = await http.post(
      Uri.parse('$uri/payment-sheet'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        // 'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'name': userProvider.user.name,
        'email': userProvider.user.email,
        "metaData": userProvider.user.id,
        'currency': 'usd',
        'city': userProvider.user.address!.city,
        'state': userProvider.user.address!.state,
        'line1':
            userProvider.user.address!.line1 + userProvider.user.address!.line2,
        'postal_code': userProvider.user.address!.postalCode,
        'country': userProvider.user.address!.country,
        'total_amount': amount,
        'items': [
          {"id": "id"}
        ],
        'request_three_d_secure': 'any',
      }),
    );

    httpErrorHandle(
        response: response, context: context, onSuccess: () async {});
    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }
    return body;
  }

  Future<void> placeOrder(
      {required BuildContext context, required double totalSum}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(Uri.parse("$uri/api/order"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': userProvider.user.address,
            'totalPrice': totalSum,
          }));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Your order has been placed!');
            UserModel userModel = userProvider.user.copyWith(
              cart: [],
            );
            userProvider.setUserFromModel(userModel);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
