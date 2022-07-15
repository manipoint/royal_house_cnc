// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final AddressModel? address;
  final String type;
  final String token;
  final List<dynamic> cart;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      this.address,
      required this.type,
      required this.token,
      required this.cart});

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    AddressModel? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address:
          map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

class AddressModel {
  final String line1;
  final String line2;
  final String postalCode;
  final String city;
  final String state;
  final String country;

  AddressModel({
    required this.line1,
    required this.line2,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'line1': line1,
      'line2': line2,
      'postalCode': postalCode,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      line1: map['line1'] ?? '',
      line2: map['line2'] ?? '',
      postalCode: map['postalCode'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
