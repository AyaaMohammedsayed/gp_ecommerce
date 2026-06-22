import 'package:shared_preferences/shared_preferences.dart';

/// Session storage backed by SharedPreferences with in-memory cache
/// for synchronous access (needed by ApiClient headers).
class AuthLocalStorage {
  AuthLocalStorage._internal();
  static final AuthLocalStorage _instance = AuthLocalStorage._internal();
  factory AuthLocalStorage() => _instance;

  // In-memory cache for synchronous access
  String? _token;
  String? _userId;
  String? _userName;
  String? _userEmail;

  /// Must be called once at app startup (before runApp) to hydrate
  /// the in-memory cache from SharedPreferences.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance._token = prefs.getString('token');
    _instance._userId = prefs.getString('userId');
    _instance._userName = prefs.getString('userName');
    _instance._userEmail = prefs.getString('userEmail');
  }

  // ── Synchronous getters (read from cache) ──
  String? getToken() => _token;
  String? getUserId() => _userId;
  String? getUserName() => _userName;
  String? getUserEmail() => _userEmail;
  bool get hasToken => _token != null && _token!.isNotEmpty;

  // ── Async setters (write to both cache + SharedPreferences) ──
  static Future<void> setSession(
    String token,
    String userName,
    String userEmail, {
    String? userId,
  }) async {
    _instance._token = token;
    _instance._userId = userId;
    _instance._userName = userName;
    _instance._userEmail = userEmail;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    if (userId != null && userId.isNotEmpty) {
      await prefs.setString('userId', userId);
    } else {
      await prefs.remove('userId');
    }
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
  }

  static Future<void> clear() async {
    _instance._token = null;
    _instance._userId = null;
    _instance._userName = null;
    _instance._userEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');

    await prefs.clear();
  }
}
