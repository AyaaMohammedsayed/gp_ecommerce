import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_colors.dart';
import '../../view_model/cubit.dart';
import '../../data/data.dart';
import '../widgets/widgets.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesCubit(FavoritesRepositoryImpl())..loadFavorites(),
      child: Scaffold(
        backgroundColor: AppColors.background,

        // 📱 الـ AppBar مطابق للتصميم
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const Icon(Icons.menu, color: AppColors.white),
          title: const Text(
            'KINETIC',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),

        // 📦 جسم الصفحة
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان "FOUR COLLECTION / FAVORITES"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: const [
                  Text(
                    'FOUR COLLECTION',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '/',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'FAVORITES',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🎯 قائمة المنتجات
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return const Center(
                        child: Text(
                          'No favorites yet',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final product = state.favorites[index];
                        return FavoriteProductCard(
                          product: product,
                          onRemove: () {
                            context.read<FavoritesCubit>().removeFavorite(product.id);
                          },
                          onAddToCart: () {
                            context.read<FavoritesCubit>().addToCart(product);
                            // ممكن تظهري رسالة نجاح
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart!'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is FavoritesError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}