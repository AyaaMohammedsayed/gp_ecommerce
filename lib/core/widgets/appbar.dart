import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinetic/core/constants/app_colors.dart';
import 'package:kinetic/features/Cart/view/screens/cart_screen.dart';
import 'package:kinetic/features/Cart/view_model/cubit.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    backgroundColor: AppColors.darkbackground,
    elevation: 0,
    centerTitle: false,
    title: Text(
      'KINETIC',
      style: TextStyle(
        color: AppColors.text1,
        fontFamily: 'SpaceGrotesk',
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu, color: AppColors.text1, size: 24.w),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      Builder(
        builder: (context) => BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final itemCount = state is CartLoaded ? state.itemCount : 0;

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.text1,
                      size: 24.w,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.routeName);
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5470),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          itemCount > 99 ? '99+' : '$itemCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}