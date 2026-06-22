import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final String? shippingLabel; // null = "Calculated at next step"
  final VoidCallback? onCheckout;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    this.shippingLabel,
    this.onCheckout,
  });

  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card2Color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Order Summary',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 16),

          // Line items
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Shipping',
            value: shippingLabel ?? 'Calculated at next step',
            valueMuted: shippingLabel == null,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Estimated Tax',
            value: '\$${tax.toStringAsFixed(2)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.dividerColor, thickness: 1),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.text1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: AppColors.text1,
                    ),
                  ),
                  const Text(
                    'USD',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'CHECKOUT SECURELY',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Trust badges
          Center(
            child: Text(
              'GUARANTEED SAFE CHECKOUT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.0,
                color: AppColors.text3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card_outlined, size: 22, color: AppColors.text3),
              const SizedBox(width: 16),
              Icon(Icons.account_balance_outlined, size: 22, color: AppColors.text3),
              const SizedBox(width: 16),
              Icon(Icons.shield_outlined, size: 22, color: AppColors.text3),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueMuted;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.text3)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: valueMuted ? AppColors.text3 : AppColors.text2,
          ),
        ),
      ],
    );
  }
}