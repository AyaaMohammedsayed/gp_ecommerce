import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gp_ecommerce/core/auth_local_storage.dart';

import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/product_details/view_model/product_cubit.dart';
import 'package:gp_ecommerce/features/product_details/view_model/product_states.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routeName = '/product-details';

  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  late int productId;
  int currentImage = 0;

  bool _isInit = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (_isInit) return;
  _isInit = true;

  productId =
      ModalRoute.of(context)!.settings.arguments as int;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final token = AuthLocalStorage().getToken();

    if (!mounted) return;
    context.read<ProductsCubit>().getProductDetails(token, productId);
  });
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
      ),
      body: BlocConsumer<ProductsCubit, ProductsState>(
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

          if (state is GetProductDetailsLoading &&
              product == null) {
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
              product.images.isNotEmpty ? product.images : [];

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
                                  errorBuilder:
                                      (context, error, stackTrace) {
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
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: List.generate(
                            safeImages.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              width:
                                  currentImage == index ? 12 : 8,
                              height:
                                  currentImage == index ? 12 : 8,
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
                                color:
                                    Colors.teal.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(15),
                              ),
                              child: Text(
                                "● IN STOCK — ${product.stock} UNITS",
                                style: const TextStyle(
                                  color: Colors.tealAccent,
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
                        data: product.description ?? "",
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

                      _buildAddToCartSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddToCartSection() {
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
                onPressed: () {},
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
              const Text(
                "1",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3C5FF),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  "Add to Cart",
                  style: TextStyle(
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
  }
}