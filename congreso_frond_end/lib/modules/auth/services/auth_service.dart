// ignore_for_file: depend_on_referenced_packages

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/jwt_response.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yaml/yaml.dart';

class AuthService {
  final AuthRepository repository;

  AuthService(this.repository);

  final storage = const FlutterSecureStorage();

  Future<({JwtResponse data, int code, String message})> autenticar(
    String email,
    String password,
    bool recordarPassword,
  ) async {
    try {
      final timer = DateTime.now();

      var time = timer.timeZoneOffset.toString().split(":");

      String horas = '';
      if (time[0].contains("-")) {
        String timeOff = time[0].replaceAll("-", "");
        try {
          if (timeOff.length == 1) {
            horas = "-0$timeOff";
          } else {
            horas = "-$timeOff";
          }
        } catch (e) {
          horas = time[0].substring(1, 2);
        }
      } else {
        horas = time[0];
        if (horas.length == 1) {
          horas = "0$horas";
        }
      }

      String minutes = time[1];

      final timeOffSet = "$horas:$minutes";

      var response = await repository.autenticar(email, password, timeOffSet);

      final jwt = JwtResponse.fromJson(response.data);
      jwt.usuario!.senha = password;
      await saveDataInSecure(jwt, email, password, recordarPassword);
      return (
        data: jwt,
        code: response.statusCode,
        message: response.statusMessage,
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    Modular.to.navigate('/login');
  }

  Future<String> getVersion() async {
    var y = await rootBundle.loadString("pubspec.yaml");
    String nrBuild = loadYaml(y)["version"].split("+")[1];
    return nrBuild;
  }

  Future<bool> saveDataInSecure(
    JwtResponse data,
    String email,
    String password,
    bool recordarPassword,
  ) async {
    try {
      final response = await repository.saveDataInSecure(
        data,
        email,
        password,
        recordarPassword,
      );
      return response;
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<Usuario?> getUsuarioLogado() async {
    try {
      final u = await repository.getUsuarioLogado();

      if (u == null || u.email!.isEmpty || u.senha!.isEmpty) {
        debugPrint('*** NO LOGADO *** ');
        Modular.to.navigate('/login');
        return null;
      }

      return u;
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
