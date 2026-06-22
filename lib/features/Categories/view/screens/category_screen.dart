import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/auth_local_storage.dart';

import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Categories/view/widgets/category_item.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_cubit.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_states.dart';

class CategoriesScreen extends StatefulWidget {
  static String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = AuthLocalStorage().getToken();

      if (!mounted) return;
      context.read<CategoriesCubit>().getCategories(token);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: BlocConsumer<CategoriesCubit, CategoriesState>(
          listener: (context, state) {
            if (state is GetCategoriesError) {
              _showSnackBar(state.error, Colors.red);
            }

            if (state is GetCategoriesSuccess) {
              _showSnackBar("Categories loaded successfully", Colors.green);
            }
          },
          builder: (context, state) {
            final cubit = context.read<CategoriesCubit>();
            final categories = cubit.categoriesResponse?.data ?? [];

            if (state is GetCategoriesLoading && categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Component Catalog',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.white),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'The Ecosystem',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'Precision-grade components for engineers and makers.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.5,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  ...categories.map(
                    (category) => Column(
                      children: [
                        CategoryItem(
                          categoryId: category.id,
                          imageName: category.coverImage,
                          title: category.name,
                          subTitle: category.slug,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
