import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondaryAppBar extends StatelessWidget {
  const SecondaryAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     double hight = MediaQuery.of(context).size.height;
    double fontSize = hight / 36.16;
    double size10 = hight / 84.4;
    final user = Provider.of<UserProvider>(context).user;
    
    return Container(
      decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
      padding: EdgeInsets.only(left: size10, right: size10, bottom: size10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
                text: "Hello, ",
                style: TextStyle(
                  fontSize: fontSize,
                  color: const Color.fromRGBO(0, 0, 0, 0.451),
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
