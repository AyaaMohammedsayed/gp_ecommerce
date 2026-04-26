import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            CircleAvatar(
              radius: 40.r,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Ayaa Mohammedsayed',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 40.h),
            DrawerItem(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {},
            ),
            DrawerItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () {},
            ),
            DrawerItem(
              icon: Icons.favorite_border,
              title: 'Favorites',
              onTap: () {},
            ),
            DrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            const Spacer(),
            Divider(color: AppColors.textLight.withValues(alpha: 0.2)),
            DrawerItem(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
