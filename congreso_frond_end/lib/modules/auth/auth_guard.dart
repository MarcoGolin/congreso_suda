import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth_loader');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final storage = const FlutterSecureStorage();

    final fromLoader = await storage.read(key: 'from_loader') == 'true';

    if (fromLoader) {
      await storage.delete(key: 'from_loader');
      return true;
    }

    await storage.write(key: 'redirect_path', value: path);
    return false;
  }
}
