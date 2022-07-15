import 'package:flutter/material.dart';

import 'content_text.dart';


class DynamicTextWidget extends StatefulWidget {
  final String text;
  const DynamicTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<DynamicTextWidget> createState() => _DynamicTextWidgetState();
}

class _DynamicTextWidgetState extends State<DynamicTextWidget> {

  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHight = 400;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHight) {
      firstHalf = widget.text.substring(0, textHight.toInt());
      secondHalf =
          widget.text.substring(textHight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
        double height = MediaQuery.of(context).size.height;
    return Container(
      child: secondHalf.isEmpty
          ? ContentText(text: firstHalf)
          : Column(
              children: [
                ContentText(
                  text: hiddenText
                      ? ('$firstHalf...')
                      : (firstHalf + secondHalf),
                ),
                SizedBox(
                  height:height/231.5,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      ContentText(
                        text: hiddenText ? "Show more" : "Show less",
                        color: const Color.fromRGBO(50, 179, 21, 1),
                        size: height/(height/16),
                      ),
                      hiddenText
                          ? Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromRGBO(50, 179, 21, 1),
                              size: height/(height/16),
                            )
                          : Icon(
                              Icons.arrow_drop_up,
                              color: const Color.fromRGBO(50, 179, 21, 1),
                              size: height/(height/16),
                            )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
