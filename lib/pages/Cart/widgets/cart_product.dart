import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/details/product_details/service/product_detail_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/cart_service.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({Key? key, required this.index}) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailService productDetailsServices = ProductDetailService();
  final CartService cartServices = CartService();

  void increaseQuantity(ProductModel productModel) {
    productDetailsServices.addToCart(
        context: context, productModel: productModel);
  }

  void decreaseQuantity(ProductModel productModel) {
    cartServices.removeFromCart(context: context, productModel: productModel);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = ProductModel.fromMap(productCart['product']);
    final quantity = productCart['quantity'];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: width / (width / 8),
          ),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: product.images[0],
                height: height / (height / 136),
                width: width / (width / 136),
              ),
              Column(
                children: [
                  Container(
                    width: width / (width / 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: width / (width / 8)),
                    child: Text(
                      product.name,
                      style: TextStyle(
                          fontSize: height / (height / 16),
                          fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: width / (width / 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: width / (width / 8)),
                    child: Text(
                      "Rs ${product.price}",
                      style: TextStyle(
                          fontSize: height / (height / 16),
                          fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    // width: width / (width / 232),
                    width: width / (width / 200),
                    padding: EdgeInsets.only(left: width / 42.8),
                    child: product.price >= 2999
                        ? const Text(
                            'Eligible for FREE Shipping',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            'Shipping Fee as per Schedule',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: height / (height / 16),
                            ),
                          ),
                  ),
                  Container(
                    width: width / (width / 200),
                    padding: EdgeInsets.only(
                        left: width / 42.8, top: height / 154.34),
                    child: product.quantity > 0
                        ? Text(
                            product.quantity < 5
                                ? "Hurry! only ${product.quantity} left in stock"
                                : 'In Stock',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                            ),
                            maxLines: 2,
                          )
                        : const Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 170, 12, 54),
                            ),
                            maxLines: 2,
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: height / (height / 10),
              horizontal: width / (width / 10)),
          child: Row(
            children: [
              InkWell(
                onTap: () => decreaseQuantity(product),
                child: Container(
                  width: width / (width / 36),
                  height: height / (height / 32),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.remove,
                    size: height / (height / 18),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: width / (width / 36),
                  height: height / (height / 32),
                  alignment: Alignment.center,
                  child: Text(
                    quantity.toString(),
                  ),
                ),
              ),
              InkWell(
                onTap: () => increaseQuantity(product),
                child: Container(
                  width: width / (width / 36),
                  height: height / (height / 32),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add,
                    size: height / (height / 18),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
