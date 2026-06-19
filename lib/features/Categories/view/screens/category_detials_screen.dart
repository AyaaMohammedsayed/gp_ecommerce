import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';
import 'package:gp_ecommerce/features/Categories/view/widgets/product_item.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_cubit.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_states.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/product_details.dart';

class CategoryDetialsScreen extends StatefulWidget {
  static String routeName = '/category_details';

  const CategoryDetialsScreen({super.key});

  @override
  State<CategoryDetialsScreen> createState() =>
      _CategoryDetialsScreenState();
}

class _CategoryDetialsScreenState extends State<CategoryDetialsScreen> {
  late int categoryId;
  late String categoryName;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) return;
    _isInit = true;

    final args = ModalRoute.of(context)!
        .settings
        .arguments as Map<String, dynamic>;

    categoryId = args['id'];
    categoryName = args['name'];

    const accessToken = 'YOUR_TOKEN';

    context.read<CategoriesCubit>().getCategoryProducts(
          accessToken,
          categoryId,
        );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_backspace_sharp, size: 32),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: BlocConsumer<CategoriesCubit, CategoriesState>(
          listener: (context, state) {
            if (state is GetCategoryProductsError) {
              _showSnackBar(state.error, Colors.red);
            }

            if (state is GetCategoryProductsSuccess) {
              _showSnackBar("Products loaded successfully", Colors.green);
            }
          },
          builder: (context, state) {
            final cubit = context.read<CategoriesCubit>();

            final products =
                cubit.categoryProductsResponse?.data ?? [];

            if (state is GetCategoryProductsLoading &&
                products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (products.isEmpty && state is GetCategoryProductsSuccess) {
              return const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Measure everything',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 7.h),

                Text(
                  '${products.length} Products',
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      ProductModel product = products[index];

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailsScreen.routeName,
                            arguments: product.id,
                          );
                        },
                        child: ProductItem(product: product),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}