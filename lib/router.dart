import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/Profile/screen/order-screen.dart';
import 'package:amazon_clone/pages/address/screens/address_page.dart';
import 'package:amazon_clone/pages/address/widget/payment_sheet.dart';
import 'package:amazon_clone/pages/admin/screens/add_product.dart';
import 'package:amazon_clone/pages/auth/screens/auth_page.dart';
import 'package:amazon_clone/pages/details/product_details/widget/zoom_page.dart';
import 'package:amazon_clone/pages/home/screen/home.dart';
import 'package:amazon_clone/pages/home/widgets/category_detail.dart';
import 'package:amazon_clone/pages/search/screens/search_page.dart';
import 'package:flutter/material.dart';

import 'pages/admin/screens/admin_order_page.dart';
import 'pages/details/product_details/screen/product_detail.dart';
import 'util/widgets/bottom_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomePage(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case ProductDetailPage.routeName:
      var product = routeSettings.arguments as ProductModel;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailPage(
                productModel: product,
              ));
    case OrderDetailPage.routeName:
      var order = routeSettings.arguments as OrderModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailPage(
          order: order,
        ),
      );
       case AdminOrderPage.routeName:
      var order = routeSettings.arguments as OrderModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminOrderPage(
          order: order,
        ),
      );
    case ZoomInOut.routeName:
      var image = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) {
            return ZoomInOut(
              productImage: image,
            );
          });
    case CategoryDetailsPage.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CategoryDetailsPage(
                category: category,
              ));
    case PaymentSheetScreen.routeName:
      var amount = routeSettings.arguments as int;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => PaymentSheetScreen(
                amount: amount,
              ));
    case SearchPage.routeName:
      var query = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SearchPage(searchQuery: query));
    case AuthPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthPage());
    case AddressPage.routeName:
      var totalAmount = routeSettings.arguments as int;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AddressPage(
                totalAmount: totalAmount,
              ));

    case AddProductPage.routName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProductPage());
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ));
  }
}
