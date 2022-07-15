import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/pages/home/widgets/category_detail.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDetailsPage.routeName,
        arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen hight 926
    double hight = MediaQuery.of(context).size.height;
    //iphone13 pro max screen hight 428
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: hight / 8.5,
      child: ListView.builder(
          itemCount: GlobalVariables.categoryImages.length,
          scrollDirection: Axis.horizontal,
          itemExtent: hight / 9,
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () => navigateToCategoryPage(
                  context, GlobalVariables.categoryImages[index]['title']!),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width / 42.8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(hight / 50),
                      child: Image.asset(
                        GlobalVariables.categoryImages[index]['image']!,
                        fit: BoxFit.cover,
                        height: hight / 10,
                        width: width / 4,
                      ),
                    ),
                  ),
                  Text(
                    GlobalVariables.categoryImages[index]['title']!,
                    style: TextStyle(
                      fontSize: hight / 77,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
