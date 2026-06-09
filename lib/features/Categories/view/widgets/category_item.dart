import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_detials_screen.dart';

class CategoryItem extends StatelessWidget {
  final String imageName;
  final String title;
  final String subTitle;

  const CategoryItem({
    super.key,
    required this.imageName,
    required this.subTitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryDetialsScreen.routeName,arguments: title);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 324.w,
        height: 428.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: AssetImage(imageName),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.black.withOpacity(0.4), // overlay for readability
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subTitle,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
