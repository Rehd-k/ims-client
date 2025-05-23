import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  static const String _tokenKey = 'access_token';

  // Save token to local storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);

    if (token != null) {
      if (JwtDecoder.isExpired(token)) {
        // Token is expired
        await prefs.remove('jwt_token');
        return null;
      } else {
        // Token is valid, return decoded token
        return JwtDecoder.decode(token);
      }
    }
    return null;
  }

  // Decode JWT to extract user data
  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  // Check if token is expired
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  // Clear token (for logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
