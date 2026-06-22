import 'package:equatable/equatable.dart';
import '../../../core/auth_local_storage.dart';
import 'profile_service.dart';

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['image'] ?? json['avatar'],
      phone: json['phone'],
    );
  }

  factory User.guest() {
    return const User(
      id: 'guest',
      name: 'Guest User',
      email: 'Sign in to access features',
      phone: 'Not provided',
    );
  }

  @override
  List<Object?> get props => [id, name, email, profileImageUrl, phone];
}

// 📦 Repository Interface
abstract class ProfileRepository {
  Future<User> getUser();
  Future<void> updateUser(User user);
  Future<void> logout();
  Future<bool> isLoggedIn();
  User? getCachedUser();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;

  ProfileRepositoryImpl({ProfileService? profileService})
    : _profileService = profileService ?? ProfileService();

  @override
  User? getCachedUser() {
    final id = AuthLocalStorage().getUserId();
    final name = AuthLocalStorage().getUserName();
    final email = AuthLocalStorage().getUserEmail();
    if (name != null && name.isNotEmpty && email != null && email.isNotEmpty) {
      return User(id: id ?? '', name: name, email: email);
    }
    return null;
  }

  @override
  Future<User> getUser() async {
    final response = await _profileService.getUserProfile();
    final data = response['data'] ?? response;
    final user = User.fromJson(data);

    // Update local cache
    if (AuthLocalStorage().getToken() != null) {
      await AuthLocalStorage.setSession(
        AuthLocalStorage().getToken()!,
        user.name,
        user.email,
        userId: user.id,
      );
    }

    return user;
  }

  @override
  Future<void> updateUser(User user) async {
    final response = await _profileService.updateProfile({
      'name': user.name,
      'email': user.email,
      if (user.phone != null) 'phone': user.phone,
    });

    final data = response['data'] ?? response;
    final updatedUser = User.fromJson(data);

    if (AuthLocalStorage().getToken() != null) {
      await AuthLocalStorage.setSession(
        AuthLocalStorage().getToken()!,
        updatedUser.name,
        updatedUser.email,
        userId: updatedUser.id,
      );
    }
  }

  @override
  Future<void> logout() async {
    await _profileService.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return AuthLocalStorage().hasToken;
  }
}
