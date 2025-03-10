import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>?> checkToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

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
