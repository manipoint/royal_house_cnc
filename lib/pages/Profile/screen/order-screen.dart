import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/pages/address/widget/loading_button.dart';
import 'package:amazon_clone/pages/admin/services/admin_services.dart';
import 'package:amazon_clone/pages/search/screens/search_page.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/order_model.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  static const String routeName = '/order-details';
  final OrderModel order;
  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  TextEditingController searchController = TextEditingController();
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void navigateToSearchPage(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

// only for admin
  changeOrderStatus(int status) async {
    await adminServices.changeOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: () {
          setState(() {
            currentStep += 1;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 15.43),
        child: CustomAppBar(
            controller: searchController,
            onFieldSubmitted: navigateToSearchPage,
            onTap: () {
              if (searchController.text.isNotEmpty) {
                navigateToSearchPage(searchController.text);
              }
            }),
      ),
      body:
      
       SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(height / (height / 8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View order details',
              style: TextStyle(
                fontSize: height / (height / 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(height / (height / 10)),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Order Date:      ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}'),
                  Text('Order ID:          ${widget.order.id}'),
                  Text('Order Total:      Rs ${widget.order.totalPrice}'),
                ],
              ),
            ),
            SizedBox(height: height / (height / 10)),
            Text(
              'Purchase Details',
              style: TextStyle(
                fontSize: height / (height / 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < widget.order.products.length; i++)
                    Row(
                      children: [
                        Image.network(
                          width: width / (width / 120),
                          height: height / (height / 120),
                          widget.order.products[i].images[0],
                          loadingBuilder: (context, child, loading) {
                            if (loading == null) return child;
                            return Center(
                              child: CircularProgressIndicator.adaptive(
                                value: loading.expectedTotalBytes != null
                                    ? loading.cumulativeBytesLoaded /
                                        loading.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: width / (width / 6)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order.products[i].name,
                                style: TextStyle(
                                  fontSize: height / (height / 18),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Qty: ${widget.order.quantity[i]}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tracking',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Stepper(
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  if (user.type == 'admin') {
                    return LoadingButton(
                        onPressed: () {
                          return changeOrderStatus(details.currentStep);
                        },
                        text: "Done");
                  }
                  return const SizedBox();
                },
                steps: [
                  Step(
                      title: const Text('Pending'),
                      content: const Text(
                        'Your order is yet to be delivered',
                      ),
                      isActive: currentStep > 0,
                      state: currentStep > 0
                          ? StepState.complete
                          : StepState.indexed),
                  Step(
                    title: const Text('Completed'),
                    content: const Text(
                      'Your order has been delivered, you are yet to sign.',
                    ),
                    isActive: currentStep > 1,
                    state: currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Received'),
                    content: const Text(
                      'Your order has been delivered and signed by you.',
                    ),
                    isActive: currentStep > 2,
                    state: currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Delivered'),
                    content: const Text(
                      'Your order has been delivered and signed by you!',
                    ),
                    isActive: currentStep >= 3,
                    state: currentStep >= 3
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
