import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/cart/view/screens/cart_screen.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    centerTitle: true,
    title: Text(
      'KINETIC',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        fontSize: 18.sp,
      ),
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu, color: Colors.white, size: 24.w),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 24.w,
          ),
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
        ),
      ),
      SizedBox(width: 8.w),
    ],
  );
}
