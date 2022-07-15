import 'package:flutter/material.dart';

import '../../const /app_const_variables.dart';

class CustomAppBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  final VoidCallback onTap;
  const CustomAppBar({
    Key? key,
    required this.controller,
    this.onFieldSubmitted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
    //iphone13 pro max screen height 428
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.appBarGradient,
        ),
      ),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            height: height / 22.05,
            margin: EdgeInsets.only(left: width / 26.75),
            child: Material(
              borderRadius: BorderRadius.circular(height / 115.75),
              elevation: 1,
              child: TextFormField(
                controller: controller,
                onFieldSubmitted: onFieldSubmitted,
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width / 71,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: height / 38.58,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(top: height / 92.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(height / 116),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(height / 116),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.black38,
                      width: 1,
                    ),
                  ),
                  hintText: 'Search Royal Design',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          height: height / 20.13,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Icon(Icons.mic, color: Colors.black, size: 25),
        ),
      ]),
    );
  }
}
