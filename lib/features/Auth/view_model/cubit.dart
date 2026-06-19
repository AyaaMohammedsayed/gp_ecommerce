import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data.dart';
import 'states.dart';
import '../../../core/auth_local_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthData authData = AuthData();

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoginLoading());

    try {
      final result = await authData.login(email: email, password: password);
      await AuthLocalStorage.setSession(
        result.token,
        result.user.name,
        result.user.email,
        userId: result.user.id.toString(),
      );

      emit(AuthLoginSuccess(result.msg));
    } catch (e) {
      emit(AuthLoginError('Invalid email or password'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthRegisterLoading());

    try {
      final result = await authData.register(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthRegisterSuccess(result.msg));
    } catch (e) {
      emit(AuthLoginError('Register failed. Please check your data.'));
    }
  }
}
