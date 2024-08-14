import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemicates/Utils/app_colors.dart';
import 'package:gemicates/view/product_description_page.dart';
import 'package:provider/provider.dart';

import '../Utils/service/remote_config_service.dart';
import '../controller/auth_controller.dart';
import '../controller/product_controller.dart';
import '../model/product_model.dart';
import 'login_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    RemoteConfigService.initializeRemoteConfig();
  }

  void _signOut(BuildContext context) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).signOut(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to sign out. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Products',
            style: TextStyle(color: AppColors.whiteColor),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: AppColors.whiteColor,
              ),
              onPressed: () => _signOut(context),
            ),
          ],
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              bool displayDiscountedPrice =
                  RemoteConfigService.displayDiscountedPrice;
              if (kDebugMode) {
                print('Display Discounted Price: $displayDiscountedPrice');
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    Product product = productProvider.products[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDescriptionPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10.0)),
                                child: Image.asset(
                                  "assets/images.jpeg",
                                  height: 120.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                          color: AppColors.primaryColorDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4.0),
                                    if (displayDiscountedPrice &&
                                        product.discountPercentage > 0) ...[
                                      Text(
                                        'Original Price: \$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: AppColors.primaryColorDark,
                                          fontSize: 14.0,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        'Discounted Price: \$${product.price.toStringAsFixed(2)} (${product.discountPercentage.toStringAsFixed(0)}% off)',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        'Price: \$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
