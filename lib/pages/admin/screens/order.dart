import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/pages/admin/services/admin_services.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:amazon_clone/util/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'admin_order_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  AdminServices adminServices = AdminServices();
  List<OrderModel>? orders = [];
  @override
  void initState() {
    super.initState();
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (_, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AdminOrderPage.routeName,
                      arguments: orderData);
                },
                child: SizedBox(
                  height: height/(height/140),
                    child: SingleProduct(
                  image: orderData.products[0].images[0],
                )),
              );
            });
  }

  getAllOrders() async {
    orders = await adminServices.getAllOrders(context);
    setState(() {});
  }
}
