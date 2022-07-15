import 'dart:io';

import 'package:amazon_clone/pages/admin/services/admin_services.dart';
import 'package:amazon_clone/util/custom_snackbar.dart';
import 'package:amazon_clone/util/custom_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../const /app_const_variables.dart';
import '../../../util/custom_button.dart';

class AddProductPage extends StatefulWidget {
  static const String routName = '/add-product';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();
  String category = 'Mobiles covers';
  List<File> images = [];
  List<String> productCategories = [
    'Mobiles covers',
    'Table Tops',
    'Doors',
    'Shirts',
    'Cup',
    'Calligraphy',
    'Jali',
    'Walls'
  ];
  void selectImages() async {
    List<File> pickImage = await pickImages();
    setState(() {
      images = pickImage;
    });
  }

  void addProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
          context: context,
          productName: productNameController.text,
          productDescription: descriptionController.text,
          productPrice: double.parse(priceController.text),
          productQuantity: double.parse(quantityController.text),
          category: category,
          images: images);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   productNameController.dispose();
  //   descriptionController.dispose();
  //   priceController.dispose();
  //   quantityController.dispose();

  // }

  @override
  Widget build(BuildContext context) {
    //iphone13 pro max screen height 926
    double height = MediaQuery.of(context).size.height;
    //iphone13 pro max screen height 428
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 35.66),
            child: Column(
              children: [
                SizedBox(height: height / 46.3),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images
                            .map((e) => Builder(
                                builder: (BuildContext context) => Image.file(e,
                                    fit: BoxFit.cover,
                                    width: width,
                                    height: height / 4.5)))
                            .toList(),
                        options: CarouselOptions(
                            viewportFraction: 1, height: height / 4.5))
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(height / 92.6),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: height / 6.17,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(height / 92.6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: height / 23.15,
                                ),
                                SizedBox(
                                  height: height / 57.87,
                                ),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: height / 57.87,
                                    color: const Color.fromRGBO(47, 43, 43, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: height / 30.86),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                SizedBox(height: height / 92.6),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                SizedBox(height: height / 92.6),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                SizedBox(height: height / 92.6),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                SizedBox(height: height / 92.6),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),
                SizedBox(height: height / 92.6),
                CustomButton(
                  color: const Color.fromRGBO(92, 203, 73, 1),
                  text: 'Sell',
                  onTap: addProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
