import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String description;
  final List<String> badges;
  final String? imagePath; // null until Api
  final VoidCallback? onRemove;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.badges = const [],
    this.imagePath,
    this.onRemove,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

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
          _ProductImage(imagePath: widget.imagePath),

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
                        widget.name,
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
                      widget.price,
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
                Text(
                  widget.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.text3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Badges row
                if (widget.badges.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: widget.badges
                        .map((b) => _Badge(label: b))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Quantity + Remove row
                Row(
                  children: [
                    _QuantityControl(
                      quantity: quantity,
                      onDecrement: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                      onIncrement: () => setState(() => quantity++),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onRemove,
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

//Sub-widgets

class _ProductImage extends StatelessWidget {
  final String? imagePath;
  const _ProductImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: imagePath != null
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
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
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
          _QtyButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.text1,
              ),
            ),
          ),
          _QtyButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
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