import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/details/product_details/screen/product_detail.dart';
import 'package:amazon_clone/pages/home/widgets/address.dart';
import 'package:amazon_clone/pages/search/service/search_service.dart';
import 'package:amazon_clone/util/widgets/custom_app_bar.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:flutter/material.dart';
import '../widgets/searched_products.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel>? products;
  TextEditingController searchController = TextEditingController();
  final SearchService service = SearchService();
  void navigateToSearchPage(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    getSearchProducts();
  }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
   
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height/15.44),
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
      body: products == null
          ? const Loader()
          : Column(
              children: [
                const Address(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailPage.routeName,
                              arguments: products![index],
                            );
                          },
                          child: SearchedProducts(
                            productModel: products![index],
                          ));
                    },
                  ),
                ),
              ],
            ),
    );
  }

  getSearchProducts() async {
    products = await service.searchProducts(
        context: context, query: widget.searchQuery);
    setState(() {});
  }
}
