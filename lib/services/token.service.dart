import 'package:jwt_decoder/jwt_decoder.dart';

import 'settings.service.dart';

class JwtService {
  static final JwtService _instance = JwtService._internal();

  factory JwtService() => _instance;

  JwtService._internal();

  String? token;

  set setToken(String? value) => token = value;

  bool get isLoggedIn => token != null;

  void logout() => {SettingsService().removeSettings(), token = null};

  Map? get decodedToken => token != null ? JwtDecoder.decode(token!) : {};
}
