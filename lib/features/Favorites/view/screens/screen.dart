import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Cart/view_model/cubit.dart';
import 'package:gp_ecommerce/features/Favorites/view_model/cubit.dart';
import 'package:gp_ecommerce/features/Home/data/models/product_model.dart';

class FavoritesScreen extends StatefulWidget {
  static String routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
            );
          }

          final loaded = state is FavoritesLoaded ? state : null;
          if (loaded == null) return const SizedBox.shrink();

          if (loaded.items.isEmpty) {
            return const _EmptyView();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            children: [
              Text(
                'YOUR COLLECTION',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: AppColors.text3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'FAVORITES',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: AppColors.text2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              ...loaded.items.map((product) {
                final isPending = loaded.pendingProductIds.contains(product.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _FavoriteCard(
                    product: product,
                    isPending: isPending,
                    onToggleFavorite: () =>
                        context.read<FavoritesCubit>().toggleFavorite(product.id),
                    onAddToCart: () {
                      context.read<CartCubit>().addToCart(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                  ),
                );
              }),
            ],
          );
          },
              );
            }
          }


class _FavoriteCard extends StatelessWidget {
  final ProductModel product;
  final bool isPending;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToCart;

  const _FavoriteCard({
    required this.product,
    required this.isPending,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: product.coverImage.isNotEmpty
                    ? Image.network(
                        product.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: isPending ? null : onToggleFavorite,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: isPending
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.favorite,
                            color: Color(0xFFFF8FA3), size: 20),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${product.effectivePrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
                if (product.description != null &&
                    product.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    product.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.text3,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: isPending ? null : onToggleFavorite,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.quantityBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.delete_outline,
                            size: 20, color: AppColors.text3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(Icons.image_outlined,
            size: 40, color: AppColors.text3.withOpacity(0.4)),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.text3),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}