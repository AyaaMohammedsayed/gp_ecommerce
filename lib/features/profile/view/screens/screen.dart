import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../Auth/view/screens/auth_screen.dart';
import '../../view_model/cubit.dart';
import '../../data/data.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // 📦 جسم الصفحة
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // 🔄 حالة التحميل
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // ❌ حالة الخطأ
          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().loadUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // 🚪 حالة تسجيل الخروج
          if (state is ProfileLoggedOut) {
            return _buildProfileView(context, User.guest());
          }

          // ✅ حالة تحميل البيانات
          if (state is ProfileLoaded) {
            return _buildProfileView(context, state.user);
          }

          // الحالة الأولية
          return _buildProfileView(context, User.guest());
        },
      ),
    );
  }

  // 👤 واجهة المستخدم المسجل
  Widget _buildProfileView(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 🖼️ صورة البروفايل
          Center(
            child: ProfileAvatar(imageUrl: user.profileImageUrl, size: 120),
          ),
          const SizedBox(height: 16),

          // 👤 اسم المستخدم
          Text(
            user.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // 📧 الإيميل
          Text(
            user.email,
            style: const TextStyle(color: AppColors.textLight, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // 📋 معلومات إضافية
          InfoTile(icon: Icons.email, label: 'Email', value: user.email),
          InfoTile(
            icon: Icons.phone,
            label: 'Phone',
            value: user.phone ?? 'Not provided',
          ),
          InfoTile(
            icon: Icons.person_outline,
            label: 'User ID',
            value: user.id,
          ),
          const SizedBox(height: 32),

          // 🚪 زر تسجيل الخروج / تسجيل الدخول
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (user.id == 'guest') {
                  Navigator.pushNamed(context, AuthScreen.routeName);
                } else {
                  _showLogoutDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.id == 'guest'
                    ? AppColors.primary
                    : AppColors.logoutRed,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                user.id == 'guest' ? 'LOGIN' : 'LOGOUT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 👤 واجهة المستخدم غير المسجل
  // 🚪 حوار تأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.textDark),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
