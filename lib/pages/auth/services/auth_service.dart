import 'dart:convert';

import 'package:amazon_clone/const%20/http_error_handler.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/pages/auth/screens/auth_page.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/custom_snackbar.dart';
import 'package:amazon_clone/util/widgets/bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const /app_const_variables.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      UserModel userModel = UserModel(
          id: '',
          name: name,
          email: email,
          password: password,
          type: '',
          token: '',
          cart: []);

      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: userModel.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Account created: Welcome to our family');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      if (kDebugMode) {
        print("error is ${e.hashCode}");
      }
    }
  }

  void signInUser({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);
          await preferences.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
//getting user data

  void getUserData(context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');
      if (token == null) {
        preferences.setString('x-auth-token', "");
      }
      var tokenResponse = await http.post(
        Uri.parse("$uri/isTokenValid"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      } else {
        Navigator.pushNamed(context, AuthPage.routeName);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
