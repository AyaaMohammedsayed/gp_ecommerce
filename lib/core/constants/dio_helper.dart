import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.post(
      url,
      data: data,
      options: Options(
        headers: token != null
            ? {
          'Authorization': 'Bearer $token',
        }
            : null,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    String? token,
  }) async {
    return await dio.get(
      url,
      options: Options(
        headers: token != null
            ? {
          'Authorization': 'Bearer $token',
        }
            : null,
      ),
    );
  }


}