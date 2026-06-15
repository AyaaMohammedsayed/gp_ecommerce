import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

/// Centralized HTTP client with automatic auth header injection and error handling.
class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final http.Client _client = http.Client();

  Map<String, String> get _headers {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final token = TokenStorage().getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Performs a GET request and returns the decoded JSON body.
  Future<dynamic> get(String url, {Map<String, String>? queryParams}) async {
    final uri = queryParams != null
        ? Uri.parse(url).replace(queryParameters: queryParams)
        : Uri.parse(url);

    final response = await _client.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  /// Performs a POST request with a JSON body.
  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  /// Performs a PUT request with a JSON body.
  Future<dynamic> put(String url, {Map<String, dynamic>? body}) async {
    final response = await _client.put(
      Uri.parse(url),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  /// Performs a DELETE request.
  Future<dynamic> delete(String url) async {
    final response = await _client.delete(
      Uri.parse(url),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body['msg'] ?? body['message'] ?? 'Unknown error occurred';
    throw ApiException(
      statusCode: response.statusCode,
      message: message.toString(),
    );
  }
}

/// Custom exception for API errors.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
