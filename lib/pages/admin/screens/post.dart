import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/pages/admin/screens/add_product.dart';
import 'package:amazon_clone/pages/admin/services/admin_services.dart';
import 'package:amazon_clone/util/widgets/single_product.dart';
import 'package:flutter/material.dart';

import '../../../util/widgets/loader.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<ProductModel>? products;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductPage.routName);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
     double width = MediaQuery.of(context).size.width;
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (_, index) {
                final productList = products![index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: width / 4,
                      child: SingleProduct(image: productList.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: height / 51.44),
                            child: Text(
                              productList.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteProduct(productList, index),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: "Add Product",
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  void getAllProducts() async {
    products = await adminServices.getAllProducts(context);
    setState(() {});
  }

  void deleteProduct(ProductModel product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
        });
  }
}
