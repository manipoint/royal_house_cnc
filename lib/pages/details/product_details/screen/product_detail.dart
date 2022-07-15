import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/address/widget/loading_button.dart';
import 'package:amazon_clone/pages/details/product_details/service/product_detail_service.dart';
import 'package:amazon_clone/pages/details/product_details/widget/zoom_page.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/widgets/custom_app_bar.dart';
import 'package:amazon_clone/util/widgets/dynamic_text_widget.dart';
import 'package:amazon_clone/util/widgets/rating_bar_stars.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../util/custom_button.dart';
import '../../../address/screens/address_page.dart';
import '../../../search/screens/search_page.dart';

class ProductDetailPage extends StatefulWidget {
  static const String routeName = '/product-details';
  final ProductModel productModel;
  const ProductDetailPage({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  PageController pageController = PageController(viewportFraction: .85);
  var _currentPageValue = 0.0;
  final double _scaleFactor = .75;
  ProductDetailService service = ProductDetailService();
  TextEditingController searchController = TextEditingController();
  double avgRating = 0;
  double myRating = 0;
  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.productModel.rating!.length; i++) {
      totalRating += widget.productModel.rating![i].rating;
      if (widget.productModel.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.productModel.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.productModel.rating!.length;
    }
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigateToSearchPage(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

  void navigateToZoomPage(String image) {
    Navigator.pushNamed(context, ZoomInOut.routeName, arguments: image);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressPage.routeName,
      arguments: sum,
    );
  }

  addToCart() {
    service.addToCart(context: context, productModel: widget.productModel);
  }
buyNow(double amount){
  int sum = amount.toInt();
  addToCart();
  navigateToAddress(sum);
}
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(height / 115.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.productModel.id!),
                RatingStars(
                  rating: avgRating,
                  sizeOfStar: height / 46.3,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height / 46.3, horizontal: height / 92.6),
            child: Center(
              child: Text(
                widget.productModel.name,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: height / 51.45),
              ),
            ),
          ),
          SizedBox(
            height: width,
            child: PageView.builder(
                controller: pageController,
                itemCount: widget.productModel.images.length,
                itemBuilder: (context, index) {
                  return _buildFeatureItems(index, width);
                }),
          ),
          DotsIndicator(
            dotsCount: widget.productModel.images.length,
            position: _currentPageValue,
            decorator: DotsDecorator(
              activeColor: Colors.cyanAccent,
              size: Size.square(height / (height / 12)),
              activeSize: Size(height / (height / 20), height / (height / 12)),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height / (height / 6))),
            ),
          ),
          SizedBox(
            height: height / (height / 12),
          ),
          Container(
            color: Colors.black12,
            height: height / 154.34,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 115.75),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: TextStyle(
                    fontSize: height / 57.875,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Rs ${widget.productModel.price}',
                      style: TextStyle(
                        fontSize: height / 38.584,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(height / 115.75),
            child: DynamicTextWidget(
              text: widget.productModel.description,
            ),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(height / 92.6),
            child: CustomButton(
              text: 'Buy Now',
              onTap: ()=>buyNow(widget.productModel.price),
            ),
          ),
          SizedBox(height: height / 92.6),
          Padding(
            padding: EdgeInsets.all(height / 92.6),
            child: CustomButton(
              text: 'Add to Cart',
              onTap: addToCart,
              color: const Color.fromRGBO(254, 216, 19, 1),
            ),
          ),
          SizedBox(height: height / 92.6),
          Container(
            color: Colors.black12,
            height: height / 154.34,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / (height / 8.0)),
            child: Center(
              child: Text(
                'Rate The Product',
                style: TextStyle(
                  fontSize: height / 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height / (height / 40)),
            child: Center(
              child: RatingBar.builder(
                  initialRating: myRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: height / (height / 8)),
                  itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber[600],
                      ),
                  onRatingUpdate: (rating) {
                    service.rateProduct(
                        context: context,
                        productModel: widget.productModel,
                        rating: rating);
                  }),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildFeatureItems(int index, double hight) {
    Matrix4 matrix4 = Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTran = hight * (1 - currentScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTran, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currentScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);

      var currentTran = hight * (1 - currentScale) / 2;

      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTran, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTran = hight * (1 - currentScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTran, 0);
    } else {
      var currentScale = .75;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(1, hight * (1 - currentScale) / 2, 1);
    }
    return Transform(
      transform: matrix4,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 4),
        height: hight / 3.4,
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: .35,
                image: NetworkImage(widget.productModel.images[index]),
                fit: BoxFit.cover),
            color: const Color.fromRGBO(244, 244, 236, 1),
            borderRadius: BorderRadius.circular(hight / (hight / 10))),
        child: GestureDetector(
          onTap: () => navigateToZoomPage(widget.productModel.images[index]),
          child: Image.network(
            widget.productModel.images[index],
            loadingBuilder: (_, child, loading) {
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
        ),
      ),
    );
  }
}
