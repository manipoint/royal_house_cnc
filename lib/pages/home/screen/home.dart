import 'package:amazon_clone/pages/home/widgets/categories.dart';
import 'package:amazon_clone/pages/home/widgets/deal_of_day.dart';
import 'package:amazon_clone/pages/search/screens/search_page.dart';
import 'package:flutter/material.dart';
import '../../../util/widgets/custom_app_bar.dart';
import '../widgets/address.dart';
import '../widgets/sliding_images.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  void navigateToSearchPage(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
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
            SizedBox(
              height: height / 92.6,
            ),
            const Categories(),
            SizedBox(
              height: height / 92.6,
            ),
            SlidingImages(
              hight: height / 4.63,
            ),
            const DealOfDay(),
          ],
        ),
      ),
    );
  }
}
