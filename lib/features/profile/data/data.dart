import 'package:equatable/equatable.dart';

// 👤 موديل المستخدم
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phone;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, profileImageUrl, phone];
}

// 📦 Repository Interface
abstract class ProfileRepository {
  Future<User> getUser();
  Future<void> updateUser(User user);
  Future<void> logout();
  Future<bool> isLoggedIn();
}

// 🗂️ Implementation وهمي (هتعدليه لما تجيبي API حقيقية)
class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<User> getUser() async {
    // محاكاة تأخير شبكة
    await Future.delayed(const Duration(seconds: 1));

    // بيانات مؤقتة
    return const User(
      id: '1',
      name: 'Aya Mohammed',
      email: 'aya@example.com',
      profileImageUrl: 'https://via.placeholder.com/150',
      phone: '+20 100 000 0000',
    );
  }

  @override
  Future<void> updateUser(User user) async {
    // هانضيف منطق التحديث هنا
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    // مسح التوكن من SharedPreferences
    await Future.delayed(const Duration(milliseconds: 500));
    // ملاحظة: هتضيفي SharedPreferences هنا
  }

  @override
  Future<bool> isLoggedIn() async {
    // التحقق من وجود توكن في SharedPreferences
    return true; // مؤقتاً
  }
}