import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/pages/Profile/widget/order.dart';
import 'package:amazon_clone/pages/Profile/widget/secondary_appbar.dart';
import 'package:amazon_clone/pages/Profile/widget/top_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen hight 926
    double hight = MediaQuery.of(context).size.height;
    //iphone13 pro max screen hight 428
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(hight / 18.52),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: hight / 115.75),
                  child: Image.asset(
                    "assets/images/Royal.png",
                    width: width / 3.56,
                    height: hight / 12,
                    // color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: width / 26.75, right: width / 26.75),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width / 26.75),
                      child: const Icon(Icons.notifications_outlined),
                    ),
                    const Icon(
                      Icons.search,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SecondaryAppBar(),
          SizedBox(
            height: hight / 92.6,
          ),
          const TopButtons(),
          SizedBox(
            height: hight / 92.6,
          ),
          const Orders()
        ],
      ),
    );
  }
}
