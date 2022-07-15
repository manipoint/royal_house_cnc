// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel> products;
  final List<int> quantity;
  final AddressModel address;
  final String userId;
  final int orderedAt;
  final int status;
  final int totalPrice;

  OrderModel(
      {required this.id,
      required this.products,
      required this.quantity,
      required this.address,
      required this.userId,
      required this.orderedAt,
      required this.status,
      required this.totalPrice});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        id: map['_id'] ?? '',
        products: List<ProductModel>.from(
            map['products']?.map((x) => ProductModel.fromMap(x['product']))),
        quantity: List<int>.from(
          map['products']?.map(
            (map) => map['quantity'],
          ),
        ),
        address: AddressModel.fromMap(map['address']),
        userId: map['userId'] ?? '',
        orderedAt: map['orderedAt'] ?? 0,
        status: map['status'] ?? 0,
        totalPrice: map['totalPrice'] ?? 0.0);
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}

class SalesModel{
  final String label;
  final int earning;

  SalesModel(this.label, this.earning);
}