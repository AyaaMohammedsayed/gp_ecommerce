import 'api_client.dart';
import 'api_constants.dart';
import 'token_storage.dart';

/// Handles authentication API calls (login/register).
/// Used temporarily for auto-login until the Auth feature is built.
class AuthService {
  final ApiClient _client = ApiClient();

  /// Registers a new user account. Returns the auth token.
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConstants.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final token = response['token'] as String;
    final user = response['user'] as Map<String, dynamic>;
    final userName = user['name'] as String? ?? name;
    final userEmail = user['email'] as String? ?? email;
    TokenStorage().setSession(token, userName, userEmail);
    return token;
  }

  /// Logs in an existing user. Returns the auth token.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConstants.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    final token = response['token'] as String;
    final user = response['user'] as Map<String, dynamic>;
    final userName = user['name'] as String? ?? 'User';
    final userEmail = user['email'] as String? ?? email;
    TokenStorage().setSession(token, userName, userEmail);
    return token;
  }

  /// Logs out the current user and clears the stored token.
  Future<void> logout() async {
    try {
      await _client.post(ApiConstants.logout);
    } finally {
      TokenStorage().clearToken();
    }
  }
}
