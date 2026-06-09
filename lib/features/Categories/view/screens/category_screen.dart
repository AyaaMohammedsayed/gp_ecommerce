import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/core/constants/app_images.dart';
import 'package:gp_ecommerce/core/widgets/appbar.dart';
import 'package:gp_ecommerce/features/Categories/view/widgets/category_item.dart';
import 'package:gp_ecommerce/features/Home/view/widgets/custom_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = '/categories';
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const CustomDrawer(),
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Component Catalog',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                'The Ecosystem',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 15.h),

              Text(
                'Precision-grade components for engineers and makers. '
                'Explore our curated selection of Arduino boards, ICs, '
                'sensors, and discrete electronic components.',
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.5,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 25.h),

              CategoryItem(
                imageName: AppImages.sensors,
                subTitle: "Temperature, IMU, proximity — sense everything.",
                title: "Sensors",
              ),

              SizedBox(height: 20.h),

              CategoryItem(
                imageName: AppImages.ICs,
                subTitle:
                    "Op-amps, 555 timers, logic gates, and shift registers — the signal chain.",
                title: "ICs",
              ),

              SizedBox(height: 20.h),

              CategoryItem(
                imageName: AppImages.transformers,
                subTitle:
                    "Step-up, step-down, and toroidal cores for every power supply design.",
                title: "Transformers",
              ),

              SizedBox(height: 20.h),

              CategoryItem(
                imageName: AppImages.transistors,
                subTitle: "BJT, MOSFET, IGBT — switch anything.",
                title: "Transistors",
              ),

              SizedBox(height: 20.h),

              CategoryItem(
                imageName: AppImages.leds,
                subTitle: "RGB, UV, IR — illuminate every circuit path.",
                title: "LEDs",
              ),
            ],
          ),
        ),
      ),
    
    );
  }
}