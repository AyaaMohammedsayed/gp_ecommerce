import '../../../core/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/auth_local_storage.dart';

/// Service layer for Profile API calls.
class ProfileService {
  final ApiClient _client = ApiClient();

  /// Fetches the current user's profile from the backend.
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await _client.get(ApiConstants.user);
    return response as Map<String, dynamic>;
  }

  /// Logs out the current user on the server, then clears local session.
  Future<void> logout() async {
    try {
      await _client.post(ApiConstants.logout);
    } catch (_) {
      // Ignore API errors on logout
    } finally {
      await AuthLocalStorage.clear();
    }
  }

  /// Updates the user's profile. Returns the updated user data.
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) async {
    final response = await _client.put(
      ApiConstants.user,
      body: body,
    );
    return response as Map<String, dynamic>;
  }
}
