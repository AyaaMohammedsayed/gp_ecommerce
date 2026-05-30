import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class FooterText extends StatelessWidget {
  final String text;

  const FooterText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textLight,
        fontSize: 10,
      ),
    );
  }
}