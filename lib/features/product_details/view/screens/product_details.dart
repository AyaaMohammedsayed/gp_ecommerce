import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String productId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    productId = ModalRoute.of(context)!.settings.arguments as String;

    context.read<ProductsCubit>().getProductDetails(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final cubit = context.read<ProductsCubit>();
          final product = cubit.productDetails;

          if (state is GetProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetProductsError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (product == null) {
            return const SizedBox();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                /// IMAGE
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: Image.network(
                    product.images,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      /// NAME
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// PRICE + STOCK
                      Row(
                        children: [
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 15),

                          if (product.showStock == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
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

                      /// OVERVIEW
                      const Text(
                        "OVERVIEW",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// HTML DESCRIPTION 🔥
                      Html(
                        data: product.description ?? "",
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "TECHNICAL SPECIFICATIONS",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildFallbackSpecs(),

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

  Widget _buildFallbackSpecs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Text(
        "Specs will be loaded from backend (if available)",
        style: TextStyle(color: Colors.white60),
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
                style: TextStyle(color: Colors.white),
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