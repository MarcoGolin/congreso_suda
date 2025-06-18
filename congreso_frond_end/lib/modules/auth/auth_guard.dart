import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/login_page');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final isLogged = await _checkAuth();
    return isLogged;
  }

  Future<bool> _checkAuth() async {
    final storage = const FlutterSecureStorage();
    // Por ejemplo: verificás si hay un token válido en SharedPreferences
    final token = await storage.read(key: 'jwttoken');
    return token != null && token.isNotEmpty;
  }
}
