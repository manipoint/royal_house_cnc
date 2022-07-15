import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/details/product_details/screen/product_detail.dart';
import 'package:amazon_clone/pages/home/service/home_service.dart';
import 'package:amazon_clone/util/widgets/loader.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  ProductModel? productModel;
  final HomeService homeService = HomeService();
  @override
  void initState() {
    super.initState();
    getDealOfDay();
  }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return productModel == null
        ? const Loader()
        : productModel!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetailScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: width / (width / 10),
                        vertical: height / (height / 16),
                      ),
                      child: Center(
                        child: Text(
                          "Deal Of the Day",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: height / (height / 24)),
                        ),
                      ),
                    ),
                    Image.network(
                      productModel!.images[0],
                      fit: BoxFit.fitHeight,
                      height: height / (height / 236),
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
                    Container(
                      padding: EdgeInsets.only(
                          left: width / (width / 16),
                          top: height / (height / 8)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Rs ${productModel!.price}",
                        style: TextStyle(
                            color: const Color.fromRGBO(58, 224, 29, 1),
                            fontSize: height / (height / 18),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                          left: width / (width / 16),
                          top: height / (height / 6),
                          right: width / (width / 40)),
                      child: Text(
                        productModel!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: height / (height / 16),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: productModel!.images
                            .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / (width / 4)),
                                  child: Image.network(
                                    e,
                                    fit: BoxFit.fitWidth,
                                    width: width / (width / 100),
                                    height: height / (height / 100),
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      return const Loader();
                                    },
                                    loadingBuilder: (context, child, loading) {
                                      if (loading == null) return child;
                                      return Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          value: loading.expectedTotalBytes !=
                                                  null
                                              ? loading.cumulativeBytesLoaded /
                                                  loading.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height / (height / 16),
                      ).copyWith(left: width / (width / 16)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'See all deals',
                        style: TextStyle(
                          color: Colors.cyan[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  void getDealOfDay() async {
    productModel = await homeService.getDealOfTheDay(context: context);
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailPage.routeName,
      arguments: productModel,
    );
  }
}
