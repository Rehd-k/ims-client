import 'package:dio/dio.dart';
import 'token.service.dart';

class AuthService {
  final Dio _dio = Dio();
  final JwtService _jwtService = JwtService();

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://example.com/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      await _jwtService.saveToken(token);

      // Decode token to extract user info
      final userData = _jwtService.decodeToken(token);
      print('User data: $userData');
    } on DioException catch (e) {
      print('Login failed: ${e.response?.data}');
    }
  }
}
