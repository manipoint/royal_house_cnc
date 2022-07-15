import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/details/product_details/screen/product_detail.dart';
import 'package:amazon_clone/pages/home/service/home_service.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../../const /app_const_variables.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String category;
  static const String routeName = '/category-details';
  const CategoryDetailsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  List<ProductModel>? productList;
  final HomeService homeService = HomeService();
  @override
  void initState() {
    super.initState();
    getCategoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen hight 926
    double hight = MediaQuery.of(context).size.height;
    //iphone13 pro max screen hight 428
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(hight / 17.8),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: productList == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 26.75, vertical: hight / 92.6),
                  child: Text(
                    'Keep shopping for ${widget.category}',
                    style: TextStyle(
                      fontSize: hight / 42,
                    ),
                  ),
                ),
                SizedBox(
                  height: hight / 4.63,
                  child: GridView.builder(
                      itemCount: productList!.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: width / 26.75),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.4,
                          mainAxisSpacing: hight / 92.6),
                      itemBuilder: (_, index) {
                        final product = productList![index];
                        return GestureDetector(
                          onTap: () {
                             Navigator.pushNamed(
                            context,
                            ProductDetailPage.routeName,
                            arguments: product,
                          );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: hight / 6.6,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(hight / 92.6),
                                    child: Image.network(
                                      product.images[0],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                  left: 0,
                                  top: hight / 185.2,
                                  right: width / 26.75,
                                ),
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  getCategoryProducts() async {
    productList = await homeService.fetchCategoryProducts(
        context: context, category: widget.category);
    setState(() {});
  }
}
