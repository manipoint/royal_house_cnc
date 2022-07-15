import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SlidingImages extends StatelessWidget {
  final double hight;
  const SlidingImages({Key? key,required this.hight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: GlobalVariables.carouselImages.map((e) {
          return Builder(
              builder: ((context) => Image.network(
                    e,
                    fit: BoxFit.cover,
                    height: hight,
                     loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  )));
        }).toList(),
        options: CarouselOptions(viewportFraction: 1, height: hight));
  }
}
