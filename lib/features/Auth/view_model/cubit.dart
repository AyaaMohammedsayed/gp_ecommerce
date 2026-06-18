import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data.dart';
import 'states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthData authData = AuthData();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoginLoading());

    try {
      final result = await authData.login(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', result.token);
      await prefs.setString('userName', result.user.name);
      await prefs.setString('userEmail', result.user.email);

      //temporory test
      await prefs.setString('token', result.token);
      print('Saved token: ${prefs.getString('token')}');


      emit(AuthLoginSuccess(result.msg));
    } catch (e) {
      emit(AuthLoginError(e.toString()));
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
      emit(AuthLoginError('Login failed. Please check your email and password.'));
    }
  }
}