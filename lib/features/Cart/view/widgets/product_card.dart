import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final List<String> badges;
  final String? imagePath;
  final int quantity;
  final bool isPending;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.badges = const [],
    this.imagePath,
    this.quantity = 1,
    this.isPending = false,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
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
          // Product Image
          _ProductImage(imagePath: imagePath),

          // Info Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description
                if (description.isNotEmpty) ...[
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: AppColors.text3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Badges row
                if (badges.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: badges.map((b) => _Badge(label: b)).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Quantity + Remove row
                Row(
                  children: [
                    _QuantityControl(
                      quantity: quantity,
                      isPending: isPending,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 16, color: AppColors.text3),
                          const SizedBox(width: 4),
                          Text(
                            'Remove',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.text3,
                            ),
                          ),
                        ],
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
}

// Sub-widgets

class _ProductImage extends StatelessWidget {
  final String? imagePath;
  const _ProductImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: (imagePath != null && imagePath!.isNotEmpty)
          ? Image.network(
              imagePath!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(Icons.image_outlined,
            size: 40, color: AppColors.text3.withOpacity(0.4)),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 11,
          letterSpacing: 0.5,
          color: AppColors.text3,
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final bool isPending;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _QuantityControl({
    required this.quantity,
    this.isPending = false,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.quantityBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _QtyButton(icon: Icons.remove, onTap: isPending ? null : onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: isPending
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.text1,
                    ),
                  )
                : Text(
                    quantity.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.text1,
                    ),
                  ),
          ),
          _QtyButton(icon: Icons.add, onTap: isPending ? null : onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 16, color: AppColors.text1),
      ),
    );
  }
}