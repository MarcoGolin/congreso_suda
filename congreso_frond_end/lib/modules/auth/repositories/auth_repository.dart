import 'dart:async';

import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/dio/rest_client_response.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/jwt_response.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage storage;

  AuthRepository(this.storage);

  Future<RestClientResponse> autenticar(
    String email,
    String password,
    String timeOffSet,
  ) async {
    try {
      final response = await Api.withOutAuth().post(
        '/auth/authenticate',
        data: {
          'username': email,
          'password': password,
          'timeOffSet': timeOffSet,
        },
      );
      return response;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<bool> saveDataInSecure(
    JwtResponse data,
    String email,
    String password,
    bool recordarPassword,
  ) async {
    try {
      data.usuario!.email = email;
      data.usuario!.senha = password;

      await storage.write(key: 'jwttoken', value: data.jwttoken);
      await storage.write(key: 'usuario', value: data.usuario!.id.toString());
      if (recordarPassword) {
        await storage.write(key: 'password', value: data.usuario!.senha);
      }
      await storage.write(key: 'email', value: data.usuario!.email);
      await storage.write(key: 'recordar', value: recordarPassword.toString());
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }

    return true;
  }

  Future<Usuario?> getUsuarioLogado() async {
    String token;
    String email;
    String password;
    bool recordarPassword = false;
    try {
      token = await storage.read(key: 'token') ?? '';
      email = await storage.read(key: 'email') ?? '';
      password = await storage.read(key: 'password') ?? '';

      final v = await storage.read(key: 'recordar');
      if (v != null) {
        if (v.compareTo('true') == 0) {
          recordarPassword = true;
        }
      }
      Usuario u = Usuario(
        email: email,
        senha: password,
        uuid: token,
        recordarPassword: recordarPassword,
      );
      return u;
    } on PlatformException {
      await storage.deleteAll();
    }
    return null;
  }

  Future<void> logout() async {
    await storage.deleteAll();
    Modular.to.navigate('/login');
  }
}
