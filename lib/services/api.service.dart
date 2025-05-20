import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../helpers/constants.dart';
import 'navigation.service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      validateStatus: (_) => true));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionError) {
          NavigationService.goToErrorPage({
            'message':
                'The Server is Unreachable Check your network connection ${error.toString()}',
          }, null);
        }
        return handler.next(error);
      },
      onRequest: (options, handler) async {
        // Retrieve the token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token') ?? '';
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }
  Future<Response> getRequest(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future postRequest(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> putRequest(
      String endpoint, Map<String, dynamic> data) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> deleteRequest(String endpoint) async {
    return await _dio.delete(endpoint);
  }
}
