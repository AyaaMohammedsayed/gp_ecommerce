import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';

class PromoCodeSection extends StatefulWidget {
  final Function(String code)? onApply;

  const PromoCodeSection({super.key, this.onApply});

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROMOTIONAL CODE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              letterSpacing: 1.2,
              color: AppColors.text3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.text2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter code',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.text3,
                    ),
                    filled: true,
                    fillColor: AppColors.card2Color,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => widget.onApply?.call(_controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card2Color,
                  foregroundColor: AppColors.text1,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'APPLY',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}