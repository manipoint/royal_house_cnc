import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class Address extends StatelessWidget {
  const Address({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen hight 926
    double hight = MediaQuery.of(context).size.height;
    //iphone13 pro max screen hight 428
    double width = MediaQuery.of(context).size.width;
    final UserModel user = Provider.of<UserProvider>(context).user;
    final AddressModel? addressModel = Provider.of<UserProvider>(context).user.address;

    return Container(
      height: hight / 22,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 177),
            Color.fromARGB(255, 142, 236, 213),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.only(left: width / 42.8),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: hight / 38.58,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: width / 53.5),
              child: Text(
                'Delivery to ${user.name} - ${"${ addressModel!.line1} ${ addressModel.line2} ${ addressModel.city} ${user.address!.state}${user.address!.country}"}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width / 53.5,
              top: hight / 463,
            ),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: hight / 52,
            ),
          )
        ],
      ),
    );
  }
}
