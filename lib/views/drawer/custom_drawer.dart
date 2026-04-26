import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              // Profile Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.drawerCard,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
                            height: 50.h,
                            width: 50.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jana Hagras',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'jana.hagras@gmail.com',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.person, color: Colors.white70, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'VIEW PROFILE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              const Divider(color: Colors.black26, thickness: 2),
              SizedBox(height: 10.h),
              // Navigation Items
              _buildDrawerItem(Icons.home_outlined, 'Home', context),
              _buildDrawerItem(Icons.shopping_cart_outlined, 'My Cart', context),
              _buildDrawerItem(Icons.favorite_outline, 'My Favorites', context),
              _buildDrawerItem(Icons.notifications_none, 'Notifications', context),
              _buildDrawerItem(Icons.settings_outlined, 'Settings', context),
              _buildDrawerItem(Icons.help_outline, 'Help & Support', context),
              
              const Spacer(),
              // Logout Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.logoutRed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10.w),
                      Text(
                        'SIGN OUT OF KINETIC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
