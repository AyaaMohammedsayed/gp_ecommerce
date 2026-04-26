import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../view_models/home_cubit/home_cubit.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_item.dart';
import '../drawer/custom_drawer.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      drawer: const CustomDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        context.read<HomeCubit>().searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Looking for products',
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.textLight, size: 24.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Select Category
                  Text(
                    'Select Category',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return CategoryItem(
                          category: category,
                          isSelected: state.selectedCategory == category.name,
                          onTap: () {
                            context.read<HomeCubit>().selectCategory(category.name);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Popular Products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.showAll ? 'All Products' : 'Popular ${state.selectedCategory}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<HomeCubit>().toggleShowAll();
                        },
                        child: Text(
                          state.showAll ? 'Show less' : 'See all',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: state.products.where((p) => 
                      (state.showAll || p.category == state.selectedCategory) && 
                      p.name.toLowerCase().contains(state.searchQuery.toLowerCase())
                    ).length,
                    itemBuilder: (context, index) {
                      final filteredProducts = state.products.where((p) => 
                        (state.showAll || p.category == state.selectedCategory) && 
                        p.name.toLowerCase().contains(state.searchQuery.toLowerCase())
                      ).toList();
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onFavoriteToggle: () {
                          context.read<HomeCubit>().toggleFavorite(product.id);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
