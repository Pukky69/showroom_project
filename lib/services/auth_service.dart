import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _isAdminKey = 'is_admin';

  static Future<void> saveUserData(
      String userId, String username, bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setBool(_isAdminKey, isAdmin);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    final username = prefs.getString(_usernameKey);
    final isAdmin = prefs.getBool(_isAdminKey);

    if (userId != null && username != null && isAdmin != null) {
      return {
        'userId': userId,
        'username': username,
        'isAdmin': isAdmin,
      };
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_isAdminKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey) != null;
  }

  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminKey) ?? false;
  }
}
