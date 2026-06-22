import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AuthField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData icon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixTap;

  const AuthField({
    super.key,
    this.controller,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
            onTap: onSuffixTap,
            child: Icon(suffixIcon, color: AppColors.textLight, size: 20),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}