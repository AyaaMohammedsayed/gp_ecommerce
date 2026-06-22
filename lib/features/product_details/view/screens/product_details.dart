import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kinetic/core/auth_local_storage.dart';
import 'package:kinetic/core/constants/app_colors.dart';
import 'package:kinetic/features/Cart/view_model/cubit.dart';
import 'package:kinetic/features/Favorites/data/favorites_service.dart' show FavoritesService;
import 'package:kinetic/features/product_details/view_model/product_cubit.dart';
import 'package:kinetic/features/product_details/view_model/product_states.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routeName = '/product-details';

  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int productId;
  int currentImage = 0;

  // Local quantity selector for "how many to add" — independent of any
  // cart-row quantity, since the product isn't necessarily in the cart yet.
  int selectedQuantity = 1;

  bool _isInit = false;
  final FavoritesService _favoritesService = FavoritesService();
  bool? _isFavorite; // null = unknown until toggled once
  bool _isTogglingFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) return;
    _isInit = true;

    productId = ModalRoute.of(context)!.settings.arguments as int;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = AuthLocalStorage().getToken();

      if (!mounted) return;
      context.read<ProductsCubit>().getProductDetails(token, productId);
    });
  }

  void _incrementSelectedQuantity() {
    setState(() => selectedQuantity++);
  }

  void _decrementSelectedQuantity() {
    if (selectedQuantity > 1) {
      setState(() => selectedQuantity--);
    }
  }

  Future<void> _toggleFavorite() async {
  if (_isTogglingFavorite) return;
  setState(() => _isTogglingFavorite = true);
  try {
    final newState = await _favoritesService.toggleFavorite(productId);
    if (!mounted) return;
    setState(() => _isFavorite = newState);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newState ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  } finally {
    if (mounted) setState(() => _isTogglingFavorite = false);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_backspace_sharp,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isTogglingFavorite ? null : _toggleFavorite,
            icon: _isTogglingFavorite
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(
                    _isFavorite == true ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite == true ? const Color(0xFFFF8FA3) : Colors.white,
                  ),
          ),
        ],
      ),
      // BlocListener for CartCubit: shows feedback for add-to-cart attempts
      // without interfering with the ProductsCubit BlocConsumer below.
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartItemAdded) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Added to cart'),
                    ),
                  );
              } else if (state is CartError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      // Real backend error message, not a generic one.
                      content: Text(state.message),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is GetProductDetailsError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.error),
                  ),
                );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ProductsCubit>();
            final product = cubit.productDetails;

            if (state is GetProductDetailsLoading && product == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (product == null) {
              return const Center(
                child: Text(
                  'No Product Found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final safeImages =
                product.images.isNotEmpty ? product.images : <String>[];

            // Don't let the user add more than what's in stock, when stock
            // is actually shown/tracked for this product.
              final maxQuantity =
                  product.showStock && product.stock > 0 ? product.stock : null;
              debugPrint('showStock=${product.showStock} stock=${product.stock} maxQuantity=$maxQuantity selectedQuantity=$selectedQuantity');
              if (maxQuantity != null && selectedQuantity > maxQuantity) {
              // Defer the setState until after this build completes.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => selectedQuantity = maxQuantity);
              });
            }

            final outOfStock =
                product.showStock && product.stock <= 0;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGES
                  Stack(
                    children: [
                      SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: safeImages.isEmpty
                            ? Container(
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              )
                            : PageView.builder(
                                itemCount: safeImages.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentImage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    safeImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      if (safeImages.length > 1)
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              safeImages.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: currentImage == index ? 12 : 8,
                                height: currentImage == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentImage == index
                                      ? AppColors.logo
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              "\$${product.discountedPrice}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 15),

                            if (product.showStock)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: outOfStock
                                      ? Colors.redAccent.withOpacity(0.2)
                                      : Colors.teal.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  outOfStock
                                      ? "● OUT OF STOCK"
                                      : "● IN STOCK — ${product.stock} UNITS",
                                  style: TextStyle(
                                    color: outOfStock
                                        ? Colors.redAccent
                                        : Colors.tealAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "OVERVIEW",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Html(
                          data: product.description,
                          style: {
                            "*": Style(color: Colors.white70),
                            "strong": Style(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            "p": Style(margin: Margins.zero),
                          },
                        ),

                        const SizedBox(height: 30),

                        _buildAddToCartSection(
                          context: context,
                          productId: product.id,
                          disabled: outOfStock,
                          maxQuantity: maxQuantity,
                        ),
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

  Widget _buildAddToCartSection({
    required BuildContext context,
    required int productId,
    required bool disabled,
    int? maxQuantity,
  }) {
    final atMax = maxQuantity != null && selectedQuantity >= maxQuantity;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final isAdding = cartState is CartLoading;

        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed:
                        disabled ? null : _decrementSelectedQuantity,
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Text(
                    '$selectedQuantity',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: (disabled || atMax)
                        ? null
                        : _incrementSelectedQuantity,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: disabled
                      ? Colors.grey
                      : const Color(0xFFB3C5FF),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: (disabled || isAdding)
                    ? null
                    : () {
                        context.read<CartCubit>().addToCart(
                              productId,
                              quantity: selectedQuantity,
                            );
                      },
                child: isAdding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            disabled ? "Out of Stock" : "Add to Cart",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}