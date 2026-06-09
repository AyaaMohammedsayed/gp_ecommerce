import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Categories/data/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.quantityBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
              child: Image.asset(
                product.ImageName,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               Text(
  product.name,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    color: AppColors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  ),
),

                  SizedBox(height: 8.h),

                  Text(
                    product.price,
                    style: TextStyle(
                      color: AppColors.logo,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}