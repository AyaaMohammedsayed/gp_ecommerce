import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_colors.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark, size: 24.w),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
