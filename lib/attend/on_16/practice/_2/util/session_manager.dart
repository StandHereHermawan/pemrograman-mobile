import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserId = 'user_id';
  static const String _keyCredentialId = 'credential_id'; // Ini string auto-gen dari firestore
  static const String _keyUsername = 'username';
  static const String _keyIsLogin = 'is_login';

  // Simpan semua data penting
  static Future<void> saveSession({
    required String userId,
    required String credentialId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyCredentialId, credentialId);
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLogin, true);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Cek Status Login
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  // Ambil Credential ID (Untuk dipakai request API/Logic lain nanti)
  static Future<String?> getCredentialId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCredentialId);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}