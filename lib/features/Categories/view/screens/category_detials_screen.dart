import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/core/constants/app_images.dart';
import 'package:gp_ecommerce/features/Categories/data/models/product.dart';
import 'package:gp_ecommerce/features/Categories/view/widgets/product_item.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/product_details.dart';

class CategoryDetialsScreen extends StatelessWidget {
  static String routeName = '/category_details';
  List Products = [
    Product(
      ImageName: AppImages.ICs,
      name: 'DHT22 Temp &\nHumidity',
      price: '\$3.99',
    ),
    Product(
      ImageName: AppImages.ICs,
      name: 'DHT22 Temp &\nHumidity',
      price: '\$3.99',
    ),
    Product(
      ImageName: AppImages.ICs,
      name: 'DHT22 Temp &\nHumidity',
      price: '\$3.99',
    ),
    Product(
      ImageName: AppImages.ICs,
      name: 'DHT22 Temp &\nHumidity',
      price: '\$3.99',
    ),
    Product(
      ImageName: AppImages.ICs,
      name: 'DHT22 Temp &\nHumidity',
      price: '\$3.99',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final String categoryName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(
            color: AppColors.logo,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_sharp, size: 32),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Measure everything',
              style: TextStyle(fontSize: 10.sp, color: AppColors.white),
            ),

            SizedBox(height: 7.h),

            Text(
              '5 Products',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.logo,
              ),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                 childAspectRatio: 0.5,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final product = Products[index];

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductDetailsScreen.routeName,
                        arguments: categoryName,
                      );
                    },
                    child: ProductItem(product: product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
