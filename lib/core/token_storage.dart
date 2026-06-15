/// Simple in-memory token storage singleton.
/// Will be upgraded to shared_preferences when Auth feature is implemented.
class TokenStorage {
  TokenStorage._internal();
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;

  String? _token;
  String? _userName;
  String? _userEmail;

  void setToken(String token) {
    _token = token;
  }

  void setSession(String token, String userName, String userEmail) {
    _token = token;
    _userName = userName;
    _userEmail = userEmail;
  }

  String? getToken() => _token;
  String? getUserName() => _userName;
  String? getUserEmail() => _userEmail;

  void clearToken() {
    _token = null;
    _userName = null;
    _userEmail = null;
  }

  bool get hasToken => _token != null && _token!.isNotEmpty;
}
