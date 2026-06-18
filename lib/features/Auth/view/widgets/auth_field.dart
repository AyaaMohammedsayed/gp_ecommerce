import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AuthField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData icon;
  final IconData? suffixIcon;
  final bool obscureText;

  const AuthField({
    super.key,
    this.controller,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
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
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textLight.withOpacity(0.6),
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.textLight, size: 20)
              : null,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}