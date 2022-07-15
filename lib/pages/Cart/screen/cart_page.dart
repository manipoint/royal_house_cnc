import 'package:amazon_clone/pages/home/widgets/address.dart';
import 'package:amazon_clone/util/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../util/custom_button.dart';
import '../../address/screens/address_page.dart';
import '../../search/screens/search_page.dart';
import '../widgets/cart_product.dart';
import '../widgets/cart_total.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController searchController = TextEditingController();
  void navigateToSearchPage(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressPage.routeName,
      arguments: sum,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
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
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Address(),
            const TotalCartPrice(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to Buy (${user.cart.length} items)',
                onTap: () => navigateToAddress(sum),
                color: Colors.yellow[600],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            SizedBox(height: height / (height / 4)),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
