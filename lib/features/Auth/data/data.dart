import '../../../core/constants/api_constants.dart';
import '../../../core/constants/dio_helper.dart';

class AuthData {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await DioHelper.postData(
      url: ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await DioHelper.postData(
      url: ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }
}

class AuthResponseModel {
  final bool success;
  final String msg;
  final String token;
  final UserModel user;

  AuthResponseModel({
    required this.success,
    required this.msg,
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      msg: json['msg'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}