import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_colors.dart';
import '../../../core/token_storage.dart';
import '../cubit/home_cubit.dart';
import '../../Cart/view/screens/screen.dart';
import '../../Favorites/view/screens/screen.dart';
import '../../profile/view/screens/screen.dart';
import '../../Auth/view/screens/screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is authenticated via TokenStorage.
    // Display dynamic user information (name and email cached from login response) if authenticated.
    // Otherwise, show generic Guest placeholders.
    final hasUser = TokenStorage().hasToken;
    final userName = TokenStorage().getUserName() ?? 'Guest User';
    final userEmail = TokenStorage().getUserEmail() ?? 'Sign in to access catalog';

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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the drawer first
                  if (hasUser) {
                    // Navigate to the user's Profile Page if signed in
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  } else {
                    // Otherwise, redirect Guest to the Login/Registration Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  }
                },
                child: Container(
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
                            child: Container(
                              height: 50.h,
                              width: 50.w,
                              color: AppColors.surfaceVariant,
                              child: Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 30.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  userEmail,
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
                          Icon(
                            hasUser ? Icons.person : Icons.login,
                            color: Colors.white70,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            hasUser ? 'VIEW PROFILE' : 'SIGN IN',
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
              ),
              SizedBox(height: 20.h),
              const Divider(color: Colors.black26, thickness: 2),
              SizedBox(height: 10.h),
              // Navigation Items
              _buildDrawerItem(
                Icons.home_outlined,
                'Home',
                context,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildDrawerItem(
                Icons.shopping_cart_outlined,
                'My Cart',
                context,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.favorite_outline,
                'My Favorites',
                context,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.notifications_none,
                'Notifications',
                context,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.settings_outlined,
                'Settings',
                context,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                Icons.help_outline,
                'Help & Support',
                context,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const Spacer(),
              // Login / Logout Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the drawer first
                  if (hasUser) {
                    // Sign out flow: Clear locally cached session, reload home view state (re-initializing it in guest mode), and notify the user
                    TokenStorage().clearToken();
                    context.read<HomeCubit>().loadHomeData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signed out successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Sign in flow: Navigate directly to the Authentication Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: hasUser ? AppColors.logoutRed : AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hasUser ? Icons.logout : Icons.login,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        hasUser ? 'SIGN OUT OF KINETIC' : 'SIGN IN TO KINETIC',
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

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    BuildContext context, {
    required VoidCallback onTap,
  }) {
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
      onTap: onTap,
    );
  }
}
