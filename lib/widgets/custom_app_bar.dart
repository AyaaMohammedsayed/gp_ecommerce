import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 20.sp,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, size: 28.w),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 28.w),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
