import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: "",
    name: "",
    email: "",
    password: "",
    address: AddressModel(
        line1: " ",
        line2: " ",
        postalCode: " ",
        city: " ",
        state: " ",
        country: " "),
    type: "",
    token: "",
    cart: [],
  );

  UserModel get user => _user;

  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }
}
