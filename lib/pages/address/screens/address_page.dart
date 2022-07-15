import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/pages/address/services/address_service.dart';
import 'package:amazon_clone/pages/address/widget/loading_button.dart';
import 'package:amazon_clone/pages/address/widget/payment_sheet.dart';
import 'package:flutter/material.dart';
import '../../../const /app_const_variables.dart';

import '../../../util/custom_text_field.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = '/address';
  final int totalAmount;
  const AddressPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final AddressService addressService = AddressService();
  void navigateToPaymentSheet(int query) {
    Navigator.pushNamed(context, PaymentSheetScreen.routeName,
        arguments: query);
  }

  Future<void> saveAddress(int amount) async {
    if (_addressFormKey.currentState!.validate()) {
      await addressService.saveUserAddress(
          context: context,
          address: AddressModel(
              city: cityController.text,
              country: countryController.text,
              line1: addressLine1Controller.text,
              line2: addressLine2Controller.text,
              state: stateController.text,
              postalCode: zipCodeController.text));
      navigateToPaymentSheet(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / (height / 60)),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(height / (height / 8.0)),
          child: Column(
            children: [
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                        controller: addressLine1Controller,
                        hintText: "Address Line 1"),
                    SizedBox(height: height / (height / 10)),
                    CustomTextField(
                        controller: addressLine2Controller,
                        hintText: "Address Line2 "),
                    SizedBox(height: height / (height / 10)),
                    CustomTextField(
                        controller: zipCodeController, hintText: "Postal Code"),
                    SizedBox(height: height / (height / 10)),
                    CustomTextField(
                      controller: cityController,
                      hintText: "City",
                    ),
                    SizedBox(height: height / (height / 10)),
                    CustomTextField(
                      controller: stateController,
                      hintText: "State",
                    ),
                    SizedBox(height: height / (height / 10)),
                    CustomTextField(
                        controller: countryController, hintText: "Country"),
                    SizedBox(height: height / (height / 10)),
                  ],
                ),
              ),
              LoadingButton(
                  onPressed: (() async {
                    return saveAddress(widget.totalAmount);
                  }),
                  text: "Pay ${widget.totalAmount}"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
