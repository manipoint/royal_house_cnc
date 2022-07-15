import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  const SingleProduct({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 428
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: width/71.33),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: width/285.34,
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Container(
          width: width/2.38,
          padding: const EdgeInsets.all(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            width:  width/2.38,
          ),
        ),
      ),
    );
  }
}
