import 'dart:convert';

import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth_loader');

  // Helper para logs con timestamp
  void _log(String msg) {
    final ts = DateTime.now().toIso8601String();
    debugPrint('[AuthGuard][$ts] $msg');
  }

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final storage = const FlutterSecureStorage();

    // _log('=== canActivate INICIO ===');
    // _log('Path solicitado: "$path"  •  route.name: "${route.name}"');

    // Estado general del storage (solo claves, sin valores)
    try {
      // final keys = await storage.readAll();
      // _log('Claves presentes en SecureStorage: ${keys.keys.toList()}');
    } catch (e) {
      _log('ERROR leyendo claves de SecureStorage: $e');
    }

    // Flags de navegación
    final fromLoader = (await storage.read(key: 'from_loader')) == 'true';
    // _log('from_loader = $fromLoader');

    // Usuario serializado
    final usuarioJson = await storage.read(key: 'usuario_json');
    // // _log(
    //   'usuario_json existe: ${usuarioJson != null}  •  length: ${usuarioJson?.length ?? 0}',
    // );

    Usuario? usuario;
    if (usuarioJson != null) {
      try {
        final map = jsonDecode(usuarioJson) as Map<String, dynamic>;
        usuario = Usuario.fromJson(map);
        // Evitamos depender de toString(); registramos lo esencial.
        try {
          // Si tu modelo expone otros campos, agregalos acá
          // final isAdmin = (usuario as dynamic).isAdmin as bool?;
          // _log('Usuario parseado OK. isAdmin=$isAdmin');
        } catch (_) {
          _log('Usuario parseado OK. (No se pudo leer isAdmin con seguridad)');
        }
      } catch (e) {
        _log(
          'ERROR parseando usuario_json: $e  •  Se elimina usuario_json corrupto.',
        );
        await storage.delete(key: 'usuario_json');
        usuario = null;
      }
    } else {
      _log('No hay usuario en storage.');
    }

    // Guardamos adónde quería ir originalmente
    // _log('Escribiendo redirect_path="$path"');
    await storage.write(key: 'redirect_path', value: path);

    // ¿Está pidiendo admin?
    final isAdminRoute = RegExp(r'^/home_admin(/|$)').hasMatch(path);
    bool? isAdminFlag;
    bool? isStaffFlag;
    bool? isFinancieroFlag;
    bool? isAudioVisualFlag;
    try {
      isAdminFlag = (usuario as dynamic)?.isAdmin as bool?;
      isStaffFlag = (usuario as dynamic)?.isStaff as bool?;
      isFinancieroFlag = (usuario as dynamic)?.isFinanciero as bool?;
      isAudioVisualFlag = (usuario as dynamic)?.isAudioVisual as bool?;
    } catch (_) {
      isAdminFlag = null;
    }
    // _log('isAdminRoute=$isAdminRoute  •  usuario?.isAdmin=$isAdminFlag');

    // Bloqueo admin si no corresponde
    if (isAdminRoute &&
        (usuario == null ||
            (isAdminFlag != true &&
                isStaffFlag != true &&
                isFinancieroFlag != true &&
                isAudioVisualFlag != true))) {
      // _log(
      //   'ACCESO ADMIN DENEGADO. Se setea redirect_path="/ingreso_restringido" y se retorna FALSE.',
      // );
      await storage.write(key: 'redirect_path', value: '/ingreso_restringido');
      // _log('=== canActivate FIN (FALSE: admin denegado) ===');
      // Si venimos del loader, liberar paso una sola vez
      if (fromLoader) {
        // _log('from_loader=TRUE -> Se borra y se permite el acceso esta vez.');
        await storage.delete(key: 'from_loader');
        // _log('=== canActivate FIN (TRUE: from_loader) ===');
        return true;
      }
      return false;
    }

    // Si venimos del loader, liberar paso una sola vez
    if (fromLoader) {
      // _log('from_loader=TRUE -> Se borra y se permite el acceso esta vez.');
      await storage.delete(key: 'from_loader');
      // _log('=== canActivate FIN (TRUE: from_loader) ===');
      return true;
    }

    // Por defecto, redirige al loader (comportamiento del RouteGuard)
    // _log('from_loader=FALSE -> Se redirige a /auth_loader (return FALSE).');
    // _log('=== canActivate FIN (FALSE: redirigir a loader) ===');
    return false;
  }
}
