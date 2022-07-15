import 'package:amazon_clone/const%20/app_const_variables.dart';
import 'package:amazon_clone/pages/Cart/screen/cart_page.dart';
import 'package:amazon_clone/pages/Profile/screen/profile_page.dart';
import 'package:amazon_clone/pages/home/screen/home.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/home-page';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  List<Widget> pages = [
    const HomePage(),
    const ProfilePage(),
    const CartPage(),
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartLength = context.watch<UserProvider>().user.cart.length;
    double hight = MediaQuery.of(context).size.height;
    double bottomBarWidth = hight / 20.095;
    double bottomBarBorderWidth = hight / 168.8;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: hight / 30.14,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: _page == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: _page == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: _page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth),
                  ),
                ),
                child: Badge(
                  elevation: 0,
                  badgeContent: Text(
                    cartLength.toString(),
                  ),
                  child: const Icon(Icons.shopping_cart_checkout_outlined),
                )),
          ),
        ],
      ),
    );
  }
}
