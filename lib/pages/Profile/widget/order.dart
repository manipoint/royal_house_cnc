import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/pages/Profile/screen/order-screen.dart';
import 'package:amazon_clone/pages/Profile/service/profile_service.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:amazon_clone/util/widgets/single_product.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<OrderModel>? orders;
  ProfileService profileService = ProfileService();
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: width / (width / 16),
                    ),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: width / (width / 16),
                    ),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: Color.fromRGBO(47, 145, 84, 1),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: height / (height / 200),
                padding: EdgeInsets.only(
                  left: width / (width / 8),
                  top: height / (height / 20),
                  right: 0,
                ),
                child: ListView.builder(
                  //  shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OrderDetailPage.routeName,
                            arguments: orders![index],
                          );
                        },
                        child: SingleProduct(
                            image: orders![index].products[0].images[0]),
                      );
                    }),
              )
            ],
          );
  }

  void fetchOrders() async {
    orders = await profileService.fetchMyOrders(context: context);
    setState(() {});
  }
}
