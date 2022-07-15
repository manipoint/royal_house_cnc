import 'package:flutter/material.dart';


class ContentText extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final double hight;
  const ContentText(
      {Key? key,
      this.color = Colors.black,
      required this.text,
      this.size = 0,
      this.hight = 1.2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size == 0? 16 : size,
        fontWeight: FontWeight.w100,
        height: hight,
      ),
    );
  }
}
