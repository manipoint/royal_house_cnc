import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/util/widgets/rating_bar_stars.dart';
import 'package:flutter/material.dart';

class SearchedProducts extends StatelessWidget {
  final ProductModel productModel;
  const SearchedProducts({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
    //iphone13 pro max screen height 428
    double width = MediaQuery.of(context).size.width;

    double totalRating = 0;
    double avgRating = 0;
    for (int i = 0; i < productModel.rating!.length; i++) {
      totalRating += productModel.rating![i].rating;
    }

    if (totalRating != 0) {
      avgRating = totalRating / productModel.rating!.length;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height / (height / 8)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: width / 42.8,
            ),
            child: Row(
              children: [
                Image.network(
                  productModel.images[0],
                  fit: BoxFit.contain,
                  height: height / 6.80,
                  width: width / 3.15,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loading) {
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
                Column(
                  children: [
                    Container(
                      width: width / 1.81,
                      padding: EdgeInsets.symmetric(horizontal: width / 42.8),
                      child: Text(
                        productModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: height / 57.87,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: width / 1.81,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: RatingStars(
                        sizeOfStar: height / 51.45,
                        rating: avgRating,
                      ),
                    ),
                    Container(
                      width: width / 1.81,
                      padding: EdgeInsets.only(
                          left: width / 42.8, top: height / 154.33),
                      child: Text(
                        'Rs ${productModel.price}',
                        style: TextStyle(
                          fontSize: height / 46.3,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: width / 1.81,
                      padding: EdgeInsets.only(left: width / 42.8),
                      child: productModel.price >= 2999
                          ? const Text(
                              'Eligible for FREE Shipping',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : const Text(
                              'Shipping Fee as per Schedule',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                    Container(
                      width: width / 1.81,
                      padding: EdgeInsets.only(
                          left: width / 42.8, top: height / 154.34),
                      child: productModel.quantity > 0
                          ? Text(
                              productModel.quantity < 5
                                  ? "Hurry! only ${productModel.quantity} left in stock"
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
