import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  // final JwtService _jwtService = JwtService();

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://example.com/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      return token;
      // await _jwtService.saveToken(token);

      // final userData = _jwtService.decodeToken(token);
      // return userData;
    } on DioException catch (_) {
      rethrow;
    }
  }
}
