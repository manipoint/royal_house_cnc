
import 'package:flutter/material.dart';

final uri = 'https://royal-house-pk.herokuapp.com';

// final uri = defaultTargetPlatform == TargetPlatform.android
//     ? 'http://10.0.2.2:4242'
//     : 'http://localhost:4242';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 141, 249, 135),
      Color.fromARGB(255, 67, 230, 103),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(26, 255, 0, 1);
  static const backgroundColor = Color.fromRGBO(226, 254, 208, 1);
  static const Color secondaryBackgroundCOlor =
      Color.fromRGBO(235, 254, 230, 1);
  static var selectedNavBarColor = const Color.fromRGBO(91, 236, 146, 1);
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];
  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/cat/mobile.jpg',
    },
    {
      'title': 'Table Tops',
      'image': 'assets/cat/table.jpg',
    },
    {
      'title': 'Shirts',
      'image': 'assets/cat/tshirt.jpg',
    },
    {
      'title': 'Doors',
      'image': 'assets/cat/door.jpg',
    },
    {
      'title': 'Cup',
      'image': 'assets/cat/cup.jpg',
    },
    {
      'title': 'Calligraphy',
      'image': 'assets/cat/Calligraphy.jpg',
    },
    {
      'title': 'Jali',
      'image': 'assets/cat/jali.jpg',
    },
    {
      'title': 'Walls',
      'image': 'assets/cat/wall.jpg',
    },
  ];
}
