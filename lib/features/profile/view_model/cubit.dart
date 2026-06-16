import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/data.dart';

part 'states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  // 📥 جلب بيانات المستخدم
  Future<void> loadUser() async {
    emit(ProfileLoading());
    try {
      final user = await repository.getUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // ✏️ تحديث بيانات المستخدم
  Future<void> updateUser(User updatedUser) async {
    emit(ProfileLoading());
    try {
      await repository.updateUser(updatedUser);
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // 🚪 تسجيل الخروج
  Future<void> logout() async {
    emit(ProfileLoading());
    try {
      await repository.logout();
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // 🔍 التحقق من حالة تسجيل الدخول
  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await repository.isLoggedIn();
      if (isLoggedIn) {
        await loadUser();
      } else {
        emit(ProfileLoggedOut());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}