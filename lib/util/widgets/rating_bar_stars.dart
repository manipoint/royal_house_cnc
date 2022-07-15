import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double sizeOfStar;
  const RatingStars({Key? key, required this.rating, required this.sizeOfStar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      rating: rating,
      itemSize: sizeOfStar,
      itemBuilder: (_, index) {
        return const Icon(
          Icons.star,
          color: Color.fromRGBO(0, 255, 0, 1),
        );
      },
    );
  }
}
