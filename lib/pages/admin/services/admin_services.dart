import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/custom_snackbar.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../const /app_const_variables.dart';

class AdminServices {
  void sellProduct(
      {required BuildContext context,
      required String productName,
      required String productDescription,
      required double productPrice,
      required double productQuantity,
      required String category,
      required List<File> images}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("dsjguwrnt", "f6opt4dl");
      List<String> imagesUrl = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: productName),
        );
        imagesUrl.add(cloudinaryResponse.secureUrl);
      }
      ProductModel productModel = ProductModel(
        name: productName,
        description: productDescription,
        quantity: productQuantity,
        images: imagesUrl,
        category: category,
        price: productPrice,
      );

      http.Response response =
          await http.post(Uri.parse('$uri/admin/add-product'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: productModel.toJson());
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added Successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<ProductModel>> getAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductModel> productList = [];
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/admin/get-products"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              productList.add(ProductModel.fromJson(
                  jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required ProductModel product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> changeOrderStatus({
    required BuildContext context,
    required int status,
    required OrderModel order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<OrderModel>> getAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<OrderModel> orderList = [];
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/admin/get-orders"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              orderList.add(OrderModel.fromJson(
                  jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  Future<Map<String, dynamic>> getEarning({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<SalesModel> sales = [];
    int totalEarning = 0;
    try {
      http.Response response =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            var res = jsonDecode(response.body);
            totalEarning = res['totalEarnings'];

            sales = [
              SalesModel('Mobiles', res['mobileCoverEarning']),
              SalesModel('Table Tops', res['table_topsEarning']),
              SalesModel('Shirts', res['shirtsEarning']),
              SalesModel('Cup', res['cupsEarning']),
              SalesModel('Doors', res['doorsEarning']),
              SalesModel('Jali', res['jaliEarning']),
              SalesModel('Calligraphy', res['calligraphyEarning']),
              SalesModel('Walls', res['wallsEarning']),
            ];
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
