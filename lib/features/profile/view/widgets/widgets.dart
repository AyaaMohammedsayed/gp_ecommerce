import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';

// 🖼️ Avatar دائري مع صورة
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ProfileAvatar({super.key, this.imageUrl, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceVariant,
      child: imageUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.textLight,
                ),
              ),
            )
          : Icon(Icons.person, size: size * 0.5, color: AppColors.textLight),
    );
  }
}

// 📋 حقل معلومات المستخدم
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
